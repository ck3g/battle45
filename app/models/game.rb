class Game < ActiveRecord::Base
  STATUSES = %[start victory defeat]

  attr_accessible :status, :name, :email

  attr_accessor :email, :name

  belongs_to :user

  validates :user_id, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :name, presence: true, if: 'user_id.blank?'
  validates :email, presence: true, email: true, if: 'user_id.blank?'

  delegate :name, :email, to: :user, prefix: true, allow_nil: true
end
