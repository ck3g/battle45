module Battle
  API_HOST = "http://battle.platform45.com"
  class PlayerNameNotSpecified < StandardError; end
  class PlayerEmailNotSpecified < StandardError; end

  class Game
    attr_reader :name, :email, :id, :coords, :status

    def initialize(name, email)
      @name = name
      @email = email
      @register_url = "#{API_HOST}/register"
      @nuke_url = "#{API_HOST}/nuke"
      @coords = [0, 0]
      @status = "init"
    end

    def register!
      raise PlayerNameNotSpecified if name.blank?
      raise PlayerEmailNotSpecified if email.blank?

      response = do_request(@register_url, { "name" => name, "email" => email })
      @id = response["id"]
      @coords = [response["x"], response["y"]]

      start

      response
    end

    def nuke(x, y)
      response = do_request @nuke_url, { id: id, x: x, y: y }
      response
    end

    private
    def start
      @status = "start"
    end

    def do_request(url, data)
      options = { content_type: :json, accept: :json }
      JSON.parse RestClient.post(url, data.to_json, options)
    end
  end
end
