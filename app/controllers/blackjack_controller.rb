class BlackjackController < ApplicationController
  before_action :before_actions

  def join
    # redirect if game full
    if @game.players.size >= 4
      flash[:alert] = "Game full"
      redirect_to games_path
      return
    else
      @player ||= @game.players.create(name: @game.players.size + 1)
    end

    # start game
    if @game.players.size >= 4
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
    end_turn
  end

  def stay
    end_turn
  end

  def split
    return render(status: :unprocessable_entity) unless @game.round == 1
    return render(status: :unprocessable_entity) unless @player.cards.first.value == @player.cards.second.value
    @player.split
    draw(hidden: true, split_hand: "left")
    draw(hidden: true, split_hand: "right")
    end_turn
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:game_id])
    end

    def set_player
      @player = Player.find_by_id(params[:player_id]) || nil
    end

    def end_turn
      split = params[:split] || nil
      @player.end_turn split
      # set next players turn
      if @player.has_turn == false
        @game.get_player_ordered((@player.name.to_i % 4) + 1).begin_turn
      end
    end

    def draw(options = {})
      @player.draw_card(Card.random(@game.id).first, options)
    end

    def before_actions
      set_game
      set_player
      unless params[:action] == "join"
        if @player.has_turn == false
          render status: :unprocessable_entity and return false
        end
      end
    end
end
