class Nuke < ActiveRecord::Base
  attr_accessible :target, :x, :y

  belongs_to :game

  attr_accessor :status, :sunk_name

  validates :x, :y, presence: true
  validates :target, presence: true, inclusion: { in: %w[user platform45] }

  delegate :remote_id, to: :game, prefix: true, allow_nil: true

  def self.prepare(params)
    nuke = self.new params
    nuke.target = 'platform45'
    return nuke unless nuke.valid?

    remote_game = Battle::Game.new id: nuke.game_remote_id
    remote_game.nuke params['x'], params['y']

    nuke.handle_remote_result_of remote_game

    nuke
  end

  def handle_remote_result_of(remote)
    self.status = remote.finished? ? remote.status : remote.nuke_status

    self.sunk_name = remote.sunk
    game.sink_the_ship remote.sunk

    game.handle_game_status(remote)
  end

  def sunk?
    self.sunk_name
  end
end
