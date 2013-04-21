module Battle
  API_HOST = "http://battle.platform45.com"
  class PlayerNameNotSpecified < StandardError; end
  class PlayerEmailNotSpecified < StandardError; end

  class Game
    attr_reader :name, :email, :id, :coords

    def initialize(name, email)
      @name = name
      @email = email
      @register_url = "#{API_HOST}/register"
      @nuke_url = "#{API_HOST}/nuke"
      @coords = [0, 0]
    end

    def register!
      raise PlayerNameNotSpecified if name.blank?
      raise PlayerEmailNotSpecified if email.blank?

      response = RestClient.post(@register_url,
                                 { "name" => name, "email" => email }.to_json,
                                 content_type: :json,
                                 accept: :json)
      json = JSON.parse response
      @id = json["id"]
      @coords = [json["x"], json["y"]]

      { game_id: @id, coordinates: @coords }
    end
  end
end
