require 'battle/game'
require 'battle/ship'

module Battle
  API_HOST = "http://battle.platform45.com"
  AVAILABLE_SHIPS = [
    { name: 'Carrier', amount: 1 },
    { name: 'Battleship', amount: 1 },
    { name: 'Destroyer', amount: 1 },
    { name: 'Submarine', amount: 2 },
    { name: 'Patrol Boat', amount: 2 }
  ]

  class PlayerNameNotSpecified < StandardError; end
  class PlayerEmailNotSpecified < StandardError; end
  class GameNotStartedYetError < StandardError; end
  class GameAlreadyFinishedError < StandardError; end

  def self.ships
    ships = []
    AVAILABLE_SHIPS.each do |ship|
      ship[:amount].times { ships << ship[:name] }
    end

    ships
  end

end
