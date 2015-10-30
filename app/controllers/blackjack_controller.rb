class BlackjackController < ApplicationController
  before_action :before_actions

  def join
    # redirect if game full
    if @game.players.size >= Game::PLAYERS
      flash[:notice] = "Game full"
      redirect_to games_path
      return
    else
      @player ||= @game.players.create(name: @game.players.size + 1)
    end

    # start game
    if @game.players.size >= Game::PLAYERS
      @game.players.create(name: "dealer", stayed: false)
      @game.update round: 1
      @game.load_deck
      @game.players.each do |player|
        player.draw_card(Card.random(@game.id).first, {hidden: true})
        player.draw_card(Card.random(@game.id).first)
      end
      @game.get_player_ordered(1).begin_turn
    end
  end

  def hit
    if @player.has_split
      draw(split_hand: params[:split])
    else
      draw
    end
    if @player.hand_value > 21
      end_turn true
    end
  end

  def stay
    end_turn true
  end

  def split
    return render(status: :unprocessable_entity) unless @game.round == 1
    return render(status: :unprocessable_entity) if @player.has_split
    return render(status: :unprocessable_entity) unless @player.cards.first.value == @player.cards.second.value
    @player.split
    draw(hidden: true, split_hand: "left")
    draw(hidden: true, split_hand: "right")
    end_turn
  end

  def end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:game_id])
    end

    def set_player
      @player = Player.find_by_id(params[:player_id]) || nil
    end

    def end_turn(stay = false)
      split = params[:split] || nil
      @player.end_turn split, stay
      # set next players turn
      if @player.has_turn == false
        # find next player

        if @player.name == "#{Game::PLAYERS}"
          next_player = @game.players.where(name: "dealer").first
        else
          next_player = @game.get_player_ordered((@player.name.to_i % Game::PLAYERS) + 1)
        end

        # if dealer just play their turn server side
        if next_player.name == "dealer"
          dealer = @game.players.where(name: "dealer").first
          if dealer.hand_value < 17 || (dealer.hand_value == 17 && dealer.has_ace?)
            dealer.draw_card(Card.random(@game.id).first)
          end
          @game.get_player_ordered(1).begin_turn
        else
          next_player.begin_turn
        end

        # end game if everyone has stayed
        if @game.players.where(stayed: false).size == 1

          # calculate all scores and charlie
          @game.players.each do |player|
            player.calculate_score!
          end
        end
      end
    end

    def draw(options = {})
      @player.draw_card(Card.random(@game.id).first, options)
    end

    def before_actions
      set_game
      set_player
      if ["hit", "stay", "split"].include? params[:action]
        if @player.has_turn == false
          render status: :unprocessable_entity and return false
        end
      end
    end
end
