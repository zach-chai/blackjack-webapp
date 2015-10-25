class BlackjackController < ApplicationController
  before_action :set_game
  before_action :set_player

  def join
    #redirect if game full

    @player ||= @game.players.create
  end

  def hit
  end

  def stay
  end

  def split
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:game_id])
    end

    def set_player
      @player = Player.find_by_id(params[:player_id]) || nil
    end
end
