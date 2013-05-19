require 'spec_helper'

describe Nuke do
  it 'has a valid factory' do
    expect(create :nuke).to be_valid
  end

  describe '.associations' do
    it { should belong_to :game }
  end

  describe '.validations' do
    context 'when valid' do
      subject { create :nuke }
      it { should validate_presence_of :x }
      it { should validate_presence_of :y }
      it { should validate_presence_of :target }
      it { should ensure_inclusion_of(:target).in_array %w[user platform45] }
    end
  end

  describe '.prepare' do
    let!(:game) { create :game, remote_id: 2188 }
    let(:params) { { 'x' => 4, 'y' => 5 } }

    it 'receives remote nuke' do
      remote_game = stub Battle::Game
      Battle::Game.should_receive(:new).
        with(id: game.remote_id).and_return remote_game
      remote_game.should_receive(:nuke).with(4, 5)
      game.nukes.prepare(params)
    end

    it 'sets the proper target' do
      VCR.use_cassette 'launch_salvos' do
        Nuke.any_instance.should_receive(:target=).with 'platform45'
        game.nukes.prepare(params)
      end
    end
  end
end
