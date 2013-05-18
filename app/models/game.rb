class Game < ActiveRecord::Base
  STATUSES = %[start victory defeat]

  attr_accessible :status, :name, :email

  attr_accessor :email, :name

  belongs_to :user

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

    game
  end

  def ships_total
    ships.inject(Hash.new(0)) { |total, ship| total[ship] += 1; total }
  end
end
