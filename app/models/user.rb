class User < ActiveRecord::Base
  attr_accessible :email, :name

  has_many :games, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  def self.from_params(params)
    where(name: params[:name],
          email: params[:email]).first_or_create
  end
end
