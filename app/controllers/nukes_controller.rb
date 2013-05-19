class NukesController < ApplicationController
  before_filter :find_game

  def create
    @nuke = @game.nukes.prepare params[:nuke]
    if @nuke.save
      redirect_to @game, notice: t(:missed)
    else
      render 'games/show'
    end
  end

  private
  def find_game
    @game = Game.find params[:game_id]
  end
end
