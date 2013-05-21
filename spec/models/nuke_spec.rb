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

    context 'when valid params' do
      it 'receives remote nuke' do
        remote_game = stub Battle::Game
        Battle::Game.should_receive(:new).
          with(id: game.remote_id).and_return remote_game
        remote_game.should_receive(:nuke).with(4, 5)
        Nuke.any_instance.should_receive(:handle_remote_result_of).
          with(remote_game)
        game.nukes.prepare(params)
      end

      it 'sets the proper target' do
        VCR.use_cassette 'launch_salvos' do
          Nuke.any_instance.should_receive(:target=).with 'platform45'
          game.nukes.prepare(params)
        end
      end
    end

    context 'when invalid params' do
      it 'doesnt receives remote nuke' do
        Nuke.any_instance.should_receive(:target=).with 'platform45'
        remote_game = stub Battle::Game
        Battle::Game.should_not_receive(:new)
        Battle::Game.any_instance.should_not_receive(:nuke)

        game.nukes.prepare({})
      end
    end
  end

  describe '.handle_remote_result_of' do
    let!(:game) { create :game }
    let!(:nuke) { create :nuke, game: game }
    let(:remote_game) do
      mock Battle::Game, nuke_status: nil, status: 'start', finished?: false,
        sunk: nil
    end

    context 'when miss' do
      before { remote_game.stub(:nuke_status).and_return 'miss' }

      it 'change nuke status to miss' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.status }.to 'miss'
      end

      it 'changes nuke state to miss' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.state }.to 'miss'
      end
    end

    context 'when hit' do
      before { remote_game.stub(:nuke_status).and_return 'hit' }

      it 'change nuke status to hit' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.status }.to 'hit'
      end

      it 'changes nuke state to hit' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.state }.to 'hit'
      end
    end

    context 'when sunk the ship' do
      before do
        remote_game.stub(:nuke_status).and_return 'hit'
        remote_game.stub(:sunk).and_return 'Submarine'
        game.should_receive(:sink_the_ship).with 'Submarine'
      end

      it 'changes status to sunk' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.status }.to 'hit'
      end

      it 'sets sunk name' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.sunk_name }.to 'Submarine'
      end
    end

    context 'when lose' do
      before do
        remote_game.stub(:finished?).and_return true
        remote_game.stub(:status).and_return 'defeat'
      end

      it 'changes nuke status to defeat' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.status }.to 'defeat'
      end
    end

    context 'when win' do
      before do
        remote_game.stub(:finished?).and_return true
        remote_game.stub(:status).and_return 'victory'
        remote_game.stub(:prize).and_return '<prize text here>'
      end

      it 'set the nuke status to victory' do
        expect {
          nuke.handle_remote_result_of remote_game
        }.to change { nuke.status }.to 'victory'
      end
    end
  end
end
