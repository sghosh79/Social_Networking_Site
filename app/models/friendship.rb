class Friendship < ActiveRecord::Base
  enum status: [ :pending, :accepted, :rejected, :removed ]
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  scope :pending_requests, -> { where("status = ?",  0 ) }
  scope :accepted_requests, -> { where("status = ?",  1) }

end
