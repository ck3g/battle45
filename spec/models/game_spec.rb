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
end
