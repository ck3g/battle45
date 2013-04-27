require 'battle/game'

module Battle
  API_HOST = "http://battle.platform45.com"

  class PlayerNameNotSpecified < StandardError; end
  class PlayerEmailNotSpecified < StandardError; end
  class GameNotStartedYetError < StandardError; end
  class GameAlreadyFinishedError < StandardError; end
end
