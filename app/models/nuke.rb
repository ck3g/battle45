class Nuke < ActiveRecord::Base
  attr_accessible :target, :x, :y

  belongs_to :game

  validates :x, :y, presence: true
  validates :target, presence: true, inclusion: { in: %w[user platform45] }

  delegate :remote_id, to: :game, prefix: true, allow_nil: true

  def self.prepare(params)
    nuke = self.new params
    nuke.target = 'platform45'
    remote_game = Battle::Game.new id: nuke.game_remote_id
    remote_game.nuke params['x'], params['y']

    nuke
  end
end
