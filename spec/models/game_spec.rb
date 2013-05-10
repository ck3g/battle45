require 'spec_helper'

describe Game do
  it 'has a valid factory' do
    expect(create :game).to be_valid
  end

  describe '.associations' do
    it { should belong_to :user }
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
end
