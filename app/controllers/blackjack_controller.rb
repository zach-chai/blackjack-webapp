class BlackjackController < ApplicationController
  before_action :set_game
  before_action :set_player

  def join
    # redirect if game full
    if @game.players.size >= 4
      flash[:notice] = "Game full"
      redirect_to games_path
    else
      @player ||= @game.players.create(name: @game.players.size + 1)
    end

    # start game
    if @game.players.size >= 4
      @game.update round: 1
      @game.load_deck
      @game.players.each do |player|
        player.draw_card Card.random(@game.id).first
        player.draw_card Card.random(@game.id).first
      end
      @game.get_player_ordered(1).begin_turn
    end
  end

  def hit
    if @player.has_split

    else
      draw
      end_turn
    end
  end

  def stay
    if @player.has_split

    else
      end_turn
    end
  end

  def split
    @player.split
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
      @player.end_turn
    end

    def draw
      @player.draw_card Card.random(@game.id).first
    end
end
