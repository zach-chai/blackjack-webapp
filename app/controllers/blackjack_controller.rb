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
      start_game
    end
  end

  def hit
    if @player.has_split
      draw(split_hand: params[:split])
      if @player.split_value(params[:split]) > 21
        end_turn true
      end
    else
      draw
      if @player.hand_value > 21
        end_turn true
      end
    end
    head 200
  end

  def stay
    end_turn true
    head 200
  end

  def split
    return render(status: :unprocessable_entity) unless @game.round == 1
    return render(status: :unprocessable_entity) if @player.has_split
    return render(status: :unprocessable_entity) unless @player.cards.first.value == @player.cards.second.value
    if request.post?
      return head(200)
    end
    @player.split
    draw(hidden: true, split_hand: "left")
    draw(hidden: true, split_hand: "right")
  end

  def start
    if @game.round >= 1
      return head(422)
    end

    # add AI players
    while @game.players.size < Game::PLAYERS
      @game.players.create(name: @game.players.size + 1, human: false)
    end

    start_game
    head 200
  end

  def end
  end

  # used to drop inactive players
  def poll
    @game.players.where(human: true).each do |player|
      unless player == @player
        if player.dropped?
          if player.has_turn
            end_turn true, player
          else
            player.drop
          end
        else
          player.update alive: player.alive + 1
        end
      end
    end
    @player.update alive: 0

    head 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find_by_id(params[:game_id]) || Game.create
    end

    def set_player
      @player = Player.find_by_id(params[:player_id]) || nil
    end

    def end_turn(stay = false, player = @player)
      split = params[:split] || nil
      player.end_turn split, stay

      # set next players turn
      if player.has_turn == false

        next_player_turn player

        # end game if everyone has stayed
        if @game.players.where(stayed: false).size == 1
          # calculate all scores and charlie
          @game.players.each do |player|
            player.calculate_score!
          end

          rank_players_and_set_results
        end
      end
    end

    def next_player_turn next_player
      loop do
        # find next player
        if next_player.name == "#{Game::PLAYERS}"
          next_player = @game.players.where(name: "dealer").first
        else
          next_player = @game.get_player_ordered(next_player.name.to_i + 1)
        end

        # if dealer just play their turn server side
        if next_player.name == "dealer"
          dealer = @game.players.where(name: "dealer").first

          while dealer.hand_value < 17 || (dealer.hand_value == 17 && dealer.has_ace?)
            dealer.draw_card(Card.random(@game.id).first)
          end

          break

        # play their turn if an AI
        elsif next_player.human == false
          play_ai_turn next_player

        # start turn if next player is human and not dropped
        elsif !next_player.dropped?
          next_player.begin_turn
          break
        end
      end
    end

    def draw(options = {})
      @player.draw_card(Card.random(@game.id).first, options)
    end

    def start_game
      @game.players.create(name: "dealer", stayed: false, human: false)
      @game.update round: 1
      @game.load_deck
      @game.players.each do |player|
        player.draw_card(Card.random(@game.id).first, {hidden: true})
        player.draw_card(Card.random(@game.id).first)
      end
      @game.get_player_ordered(1).begin_turn
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

    def play_ai_turn next_player
      # split if possible
      if next_player.cards.first.value == next_player.cards.second.value
        next_player.split
        next_player.draw_card(Card.random(@game.id).first, split_hand: "left", hidden: true)
        next_player.draw_card(Card.random(@game.id).first, split_hand: "right", hidden: true)
      end
      # hit or stay
      if next_player.has_split
        while hit_check next_player, "left"
          next_player.draw_card(Card.random(@game.id).first, split_hand: "left")
          break if next_player.split_value("left") > 21
        end
        next_player.end_turn "left", true
        while hit_check next_player, "right"
          next_player.draw_card(Card.random(@game.id).first, split_hand: "right")
          break if next_player.split_value("right") > 21
        end
        next_player.end_turn "right", true
      else
        while hit_check next_player
          next_player.draw_card(Card.random(@game.id).first)
          break if next_player.hand_value > 21
        end
        next_player.end_turn nil, true
      end
    end

    def hit_check(the_player, split = nil)
      if split
        the_hand_value = the_player.split_value split
      else
        the_hand_value = the_player.hand_value
      end
      ace_ten_visible = false
      @game.players.each do |player|
        if player.cards.where(hidden: false).where("value in (?)", ["Ace", "Jack", "King", "Queen", "Ten"]).size > 1
          ace_ten_visible = true
        end
      end
      better_hand = false
      @game.players.each do |player|
        if the_player != player
          if player.has_split
            if player.split_value("left", true) > the_hand_value - 10
              better_hand = true
            elsif player.split_value("right", true) > the_hand_value - 10
              better_hand = true
            end
          elsif player.hand_value(true) > the_hand_value - 10
            better_hand = true
          end
        end
      end

      result = if the_hand_value == 21
        false
      elsif ace_ten_visible
        true
      elsif the_hand_value > 17 && the_hand_value < 21
        better_hand
      else
        true
      end
      result
    end

    def rank_players_and_set_results
      @game.players.each do |player|
        if player.has_charlie?
          player.update rank: 1, result: "Wins with 7-card charlie"
          return
        end
      end
      score = 0
      players = @game.players.where("score < 22").order(score: :desc)

      if players.second && players.first.score == players.second.score
        if players.first.cards.size == players.second.cards.size
          players.first.update rank: 1, result: "Tie same score and hand size"
          players.second.update rank: 1, result: "Tie same score and hand size"
        elsif players.first.cards.size < players.second.cards.size
          players.first.update rank: 1, result: "Wins with highest score and fewest cards"
        else
          players.second.update rank: 1, result: "Wins with highest score and fewest cards"
        end
      else
        players.first.update rank: 1
        if players.first.score == 21
          players.first.update result: "Wins with Blackjack"
        else
          players.first.update result: "Wins with highest score"
        end
      end

      @game.players.each do |player|
        if player && player.score > 21
          player.update result: "Bust"
        end
      end
    end
end
