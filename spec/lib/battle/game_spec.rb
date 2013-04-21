require 'spec_helper'
require 'battle/game'

describe Battle::Game do
  def load_fixture(name)
    File.open File.join("spec", "fixtures", "#{name}.json")
  end

  let(:game) { Battle::Game.new("Bob", "bob@example.com") }
  let(:headers) do
    { 'Accept'=>'application/json', 'Content-Type'=>'application/json' }
  end

  it "stores player name" do
    expect(game.name).to eq "Bob"
  end

  it "stores player email" do
    expect(game.email).to eq "bob@example.com"
  end

  describe "#register!" do
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

  describe '#nuke' do
    before do
      game.stub(:id).and_return "2746"
    end

    context 'when miss' do
      before do
        body = "{\"id\":\"2746\",\"x\":5,\"y\":9}"
        stub_request(:post, "http://battle.platform45.com/nuke").
          with(body: body, headers: headers).
          to_return(status: 200, body: load_fixture("nuke_miss"), headers: {})

        unless example.metadata[:skip_nuke]
          game.nuke(1, 2)
        end
      end

      it 'launch the salvos', skip_nuke: true do
        expect(game.nuke(5, 9)).to eq({ 'status' => 'miss', 'x' => 0, 'y' => 6 })
      end
    end
  end
end
