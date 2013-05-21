class GamesController < ApplicationController
  respond_to :html

  before_filter :new_game, only: [:index, :new]
  before_filter :find_game, only: [:show]

  def index
    @games = Game.order('created_at DESC')
  end

  def new
  end

  def show
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
end
