require 'spec_helper'
require 'battle/game'

describe Battle::Game do
  def load_fixture(name)
    File.open File.join("spec", "fixtures", "#{name}.json")
  end

  let(:game) { Battle::Game.new("Bob", "bob@example.com") }

  it "stores player name" do
    expect(game.name).to eq "Bob"
  end

  it "stores player email" do
    expect(game.email).to eq "bob@example.com"
  end

  describe "#register!" do
    let(:headers) do
      { 'Accept'=>'application/json', 'Content-Type'=>'application/json' }
    end
    let(:response_body) { load_fixture "register" }

    context "when success" do
      before do
        body = "{\"name\":\"Bob\",\"email\":\"bob@example.com\"}"
        stub_request(:post, "http://battle.platform45.com/register").
          with(body: body, headers: headers).
          to_return(status: 200, body: response_body, headers: {})

        game.register! unless example.metadata[:skip_register]
      end

      it "returns game id and coordinates", skip_register: true do
        expect(game.register!).to eq({ game_id: "2746", coordinates: [7, 6] })
      end

      it "stores game id" do
        expect(game.id).to eq "2746"
      end

      it "gets last nuke coordinates" do
        expect(game.coords).to eq [7, 6]
      end
    end

    context "when name not specified" do
      let(:game) { Battle::Game.new("", "bob@example.com") }
      before do
        body = "{\"name\":\"\",\"email\":\"bob@example.com\"}"
        stub_request(:post, "http://battle.platform45.com/register").
          with(body: body, headers: headers).
          to_return(status: 400, body: response_body, headers: {})
      end

      it "raises the exception" do
        expect{game.register!}.to raise_error Battle::PlayerNameNotSpecified
      end
    end

    context "when email not specified" do
      let(:game) { Battle::Game.new("Bob", "") }
      before do
        body = "{\"name\":\"Bob\",\"email\":\"\"}"
        stub_request(:post, "http://battle.platform45.com/register").
          with(body: body, headers: headers).
          to_return(status: 400, body: response_body, headers: {})
      end

      it "raises the exception" do
        expect{game.register!}.to raise_error Battle::PlayerEmailNotSpecified
      end
    end
  end
end
