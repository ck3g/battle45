class NukesController < ApplicationController
  before_filter :find_game

  def create
    @nuke = @game.nukes.prepare params[:nuke]
    if @nuke.save
      redirect_to @game, notice: notice
    else
      @bf = Battlefield.new
      render 'games/show'
    end
  end

  private
  def find_game
    @game = Game.find params[:game_id]
  end

  def notice
    if @nuke.sunk?
      t("nuke.messages.sunk", name: @nuke.sunk_name)
    else
      t("nuke.messages.#{ @nuke.status }")
    end
  end
end
