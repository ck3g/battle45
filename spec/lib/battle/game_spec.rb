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

  it "init the game" do
    expect(game.status).to eq "init"
  end

  describe "#register!" do
    let(:response_body) { load_fixture "register" }

    context "when success" do
      before do
        body = "{\"name\":\"Bob\",\"email\":\"bob@example.com\"}"
        stub_request(:post, "http://battle.platform45.com/register").
          with(body: body, headers: headers).
          to_return(status: 200, body: response_body, headers: {})
      end

      it "returns game id and coordinates" do
        expect(game.register!).to eq({ "id" => "2746", "x" => 7, "y" => 6 })
      end

      it "stores game id" do
        expect { game.register! }.to change { game.id }.to "2746"
      end

      it "gets last nuke coordinates" do
        expect { game.register! }.to change { game.coords }.to [7, 6]
      end

      it "begins the game" do
        expect { game.register! }.to change { game.status }.to "start"
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
        expect { game.register! }.to raise_error Battle::PlayerNameNotSpecified
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
        expect { game.register! }.to raise_error Battle::PlayerEmailNotSpecified
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
      end

      it 'launch the salvos' do
        expect(game.nuke(5, 9)).to eq({ 'status' => 'miss', 'x' => 0, 'y' => 6 })
      end

      it "don't change game status" do
        expect { game.nuke(5, 9) }.to_not change { game.status }
      end
    end

    context "when hit battleship" do
      before do
        body = "{\"id\":\"2746\",\"x\":5,\"y\":9}"
        stub_request(:post, "http://battle.platform45.com/nuke").
          with(body: body, headers: headers).
          to_return(status: 200, body: load_fixture("nuke_hit_battleship"), headers: {})
      end

      it 'gets proper response' do
        expect(game.nuke(5, 9)).to eq({ "status" => "hit",
                                        "sunk" => "battleship",
                                        "x" => 1,
                                        "y" => 7 })
      end

      it "don't change game status" do
        expect { game.nuke(5, 9) }.to_not change { game.status }
      end
    end
  end
end
