class Game < ActiveRecord::Base
  STATUSES = %[start victory defeat]

  attr_accessible :status, :name, :email, :prize, :ships

  attr_accessor :email, :name

  belongs_to :user
  has_many :nukes, dependent: :destroy

  validates :user_id, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :name, presence: true, if: 'user_id.blank?'
  validates :email, presence: true, email: true, if: 'user_id.blank?'

  delegate :name, :email, to: :user, prefix: true, allow_nil: true

  def self.init(params)
    game = Game.new params

    return game unless game.valid?

    remote_game = Battle::Game.new params['name'], params['email']
    remote_game.register!
    game.remote_id = remote_game.id
    game.ships = remote_game.ships.map(&:name)
    game.nukes.new x: remote_game.coords.first,
                   y: remote_game.coords.last,
                   target: 'user'

    game
  end

  def ships_total
    ships.inject(Hash.new(0)) { |total, ship| total[ship] += 1; total }
  end

  def new_nuke
    nukes.new
  end

  def finished?
    status == 'victory' || status == 'defeat'
  end

  def handle_game_status(remote_game)
    update_attributes status: 'defeat' if remote_game.status == 'defeat'

    if remote_game.status == 'victory'
      update_attributes status: 'victory', prize: remote_game.prize
    end
  end

  def sink_the_ship(name)
    return unless name

    ships.delete_at(ships.index(name) || ships.length)
    update_attributes ships: ships
  end
end
