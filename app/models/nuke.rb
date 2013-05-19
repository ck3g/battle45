class Nuke < ActiveRecord::Base
  attr_accessible :target, :x, :y

  belongs_to :game

  validates :x, :y, presence: true
  validates :target, presence: true, inclusion: { in: %w[user platform45] }

  def self.prepare(params)
    nuke = self.new params
    nuke.target = 'platform45'

    nuke
  end
end
