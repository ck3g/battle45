require 'spec_helper'

shared_examples 'field_size' do
  it { should eq 220 }
end

describe Battlefield do
  describe '.new' do
    subject { Battlefield.new cells: 10, cell_size: 20 }
    its(:cells) { should eq 10 }
    its(:cell_size) { should eq 20 }
  end

  describe '#field_size' do
    subject { Battlefield.new.field_size }
    it_behaves_like 'field_size'
  end

  describe '#width' do
    subject { Battlefield.new.width }
    it_behaves_like 'field_size'
  end

  describe '#height' do
    subject { Battlefield.new.height }
    it_behaves_like 'field_size'
  end

  describe '#cell_width' do
    subject { Battlefield.new.cell_width }
    it { should eq 19 }
  end

  describe '#cell_height' do
    subject { Battlefield.new.cell_height }
    it { should eq 19 }
  end

  describe '#ox_label_x' do
    subject { Battlefield.new.ox_label_x(2) }
    it { should eq 50 }
  end

  describe '#ox_label_y' do
    subject { Battlefield.new.ox_label_y }
    it { should eq -5 }
  end

  describe '#oy_label_dx' do
    subject { Battlefield.new.oy_label_dx }
    it { should eq -10 }
  end

  describe '#oy_label_dy' do
    subject { Battlefield.new.oy_label_dy(2) }
    it { should eq 55 }
  end

  describe '#translate_ox' do
    subject { Battlefield.new.translate_ox(2) }
    it { should eq 43 }
  end

  describe '#cell_y' do
    subject { Battlefield.new.cell_y(2) }
    it { should eq 42 }
  end
end
