require 'spec_helper'

describe Game do
  let(:ships_list) do
    [
      'Carrier',
      'Battleship',
      'Destroyer',
      'Submarine',
      'Submarine',
      'Patrol Boat',
      'Patrol Boat'
    ]
  end
  it 'has a valid factory' do
    expect(create :game).to be_valid
  end

  describe '.associations' do
    it { should belong_to :user }
    it { should have_many(:nukes).dependent(:destroy) }
  end

  describe '.validation' do
    context 'when valid' do
      subject { create :game }
      it { should validate_presence_of :user_id }
      it do
        should ensure_inclusion_of(:status).in_array(
          %w[start victory defeat])
      end
    end
  end

  describe '.init' do
    let(:user) { create :user }
    let(:name) { 'Jack' }
    let(:email) { 'jack-the-sparrow@example.com' }
    let(:params) do
      { 'name' => name, 'email' => email }
    end

    subject do
      VCR.use_cassette 'init_game' do
        user.games.init(params)
      end
    end

    it { should be_kind_of Game }
    its(:remote_id) { should eq 2186 }
    its(:ships) { should eq ships_list }

    it "registers Platform45's nuke" do
      expect { subject.save }.to change { Nuke.count }.by(1)
    end
  end

  describe '#ships_total' do
    let(:game) { build :game, ships: ships_list }
    subject { game.ships_total }
    it do
      should eq({
        'Carrier' => 1,
        'Battleship' => 1,
        'Destroyer' => 1,
        'Submarine' => 2,
        'Patrol Boat' => 2
      })
    end
  end

  describe '#handle_game_status' do
    let!(:game) { create :game }
    let(:remote_game) do
      mock Battle::Game, nuke_status: nil, status: 'start', finished?: false,
        sunk: nil
    end

    context 'when lose' do
      before do
        remote_game.stub(:finished?).and_return true
        remote_game.stub(:status).and_return 'defeat'
      end

      it 'changes game status to defeat' do
        expect {
          game.handle_game_status remote_game
        }.to change { game.status }.to 'defeat'
      end
    end

    context 'when win' do
      before do
        remote_game.stub(:status).and_return 'victory'
        remote_game.stub(:prize).and_return '<prize text here>'
      end

      it 'changes game status to victory' do
        expect {
          game.handle_game_status remote_game
        }.to change { game.status }.to 'victory'
      end

      it 'grabs the prize' do
        expect {
          game.handle_game_status remote_game
        }.to change { game.prize }.to '<prize text here>'
      end
    end
  end

  describe '#sink_the_ship' do
    let!(:game) { create :game }

    context 'when ship name present' do
      it 'decreases ships count' do
        expect {
          game.sink_the_ship 'Submarine'
        }.to change { game.ships }.to %w[Carrier Battleship Submarine]
      end
    end

    context 'when ship name is blank' do
      it 'dont changes ships' do
        expect {
          game.sink_the_ship nil
        }.to_not change { game.ships }
      end
    end
  end
end
