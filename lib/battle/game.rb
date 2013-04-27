module Battle
  class Game
    attr_reader :name, :email, :id, :coords, :status, :ships

    STATUSES = %w[start victory lost]

    def initialize(name, email)
      @name = name
      @email = email
      @coords = [0, 0]
      @status = "init"
      @ships = []
      Battle.ships.each { |name| @ships << Ship.new(name) }
    end

    def register!
      raise PlayerNameNotSpecified if name.blank?
      raise PlayerEmailNotSpecified if email.blank?

      response = do_request(REGISTER_URL, { "name" => name, "email" => email })
      @id = response["id"]
      @coords = [response["x"], response["y"]]

      start

      response
    end

    def nuke(x, y)
      raise GameNotStartedYetError if init?
      raise GameAlreadyFinishedError if finished?

      response = do_request NUKE_URL, { id: id, x: x, y: y }
      victory if response["prize"].present?
      lost if response["game_status"] == "lost"
      response
    end

    def init?
      status == "init"
    end

    def finished?
      status == "lost" || status == "victory"
    end

    private
    STATUSES.each do |status|
      define_method status do
        @status = status
      end
    end

    def do_request(url, data)
      options = { content_type: :json, accept: :json }
      JSON.parse RestClient.post(url, data.to_json, options)
    end
  end
end
