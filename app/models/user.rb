class User < ApplicationRecord
  validates_uniqueness_of :username
  validates_presence_of :username
  validates_length_of :username, minimum: 1, allow_blank: false

  has_secure_password

  scope :alphabetical, -> { order(:username) }
end
