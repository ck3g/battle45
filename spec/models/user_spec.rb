require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(create :user).to be_valid
  end

  describe '.associations' do
    it { should have_many(:games).dependent :destroy }
  end

  describe '.validations' do
    context 'when valid' do
      subject { create :user }
      it { should validate_presence_of :name }
      it { should validate_presence_of :email }
      it { should validate_uniqueness_of :email }
      it { should allow_value("valid@email.com").for :email }
    end

    context 'when invalid' do
      subject { build :user }
      it { should_not allow_value("invalid-email").for :email }
    end
  end
end
