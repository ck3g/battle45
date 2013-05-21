require 'spec_helper'

shared_examples 'field_size' do
  it { should eq 220 }
end

describe Battlefield do
  let(:battlefield) { Battlefield.new }
  describe '.new' do
    subject { Battlefield.new cells: 10, cell_size: 20 }
    its(:cells) { should eq 10 }
    its(:cell_size) { should eq 20 }
  end

  describe '#field_size' do
    subject { battlefield.field_size }
    it_behaves_like 'field_size'
  end

  describe '#width' do
    subject { battlefield.width }
    it_behaves_like 'field_size'
  end

  describe '#height' do
    subject { battlefield.height }
    it_behaves_like 'field_size'
  end

  describe '#cell_width' do
    subject { battlefield.cell_width }
    it { should eq 19 }
  end

  describe '#cell_height' do
    subject { battlefield.cell_height }
    it { should eq 19 }
  end

  describe '#ox_label_x' do
    subject { battlefield.ox_label_x(2) }
    it { should eq 50 }
  end

  describe '#ox_label_y' do
    subject { battlefield.ox_label_y }
    it { should eq -5 }
  end

  describe '#oy_label_dx' do
    subject { battlefield.oy_label_dx }
    it { should eq -10 }
  end

  describe '#oy_label_dy' do
    subject { battlefield.oy_label_dy(2) }
    it { should eq 55 }
  end

  describe '#translate_ox' do
    subject { battlefield.translate_ox(2) }
    it { should eq 43 }
  end

  describe '#cell_y' do
    subject { battlefield.cell_y(2) }
    it { should eq 42 }
  end

  describe '#cell_state' do
    let(:nukes) do
      [
        build(:nuke, x: 1, y: 2, state: 'hit'),
        build(:nuke, x: 2, y: 1, state: 'miss')
      ]
    end

    context 'when nukes is nil' do
      subject { battlefield.cell_state(nil, 3, 3) }
      it { should be_nil }
    end

    context 'when wasnt fired at the cell' do
      subject { battlefield.cell_state(nukes, 3, 3) }
      it { should be_nil }
    end

    context 'when nuke is missed' do
      subject { battlefield.cell_state(nukes, 2, 1) }
      it { should eq 'miss' }
    end

    context 'when nuke is hit' do
      subject { battlefield.cell_state(nukes, 1, 2) }
      it { should eq 'hit' }
    end
  end
end
