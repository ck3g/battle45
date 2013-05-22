class GamesController < ApplicationController
  respond_to :html

  before_filter :new_game, only: [:index, :new]
  before_filter :find_game, only: [:show]
  before_filter :find_nukes, only: [:show]

  def index
    @games = Game.includes(:user).order('created_at DESC')
  end

  def new
  end

  def show
    @bf = Battlefield.new
  end

  def create
    @user = User.from_params(params[:game])
    @game = @user.games.init params[:game]
    flash.notice = t(:battle_began) if @game.save
    respond_with @game
  end

  private
  def new_game
    @game = Game.new
  end

  def find_game
    @game = Game.find params[:id]
  end

  def find_nukes
    @nukes = Nuke.where(game_id: @game.id).all
  end
end
