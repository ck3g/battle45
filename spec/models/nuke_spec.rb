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
end
