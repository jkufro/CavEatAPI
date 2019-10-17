require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'basic validations' do
    should validate_uniqueness_of(:username)
    should validate_presence_of(:username)
    should validate_length_of(:username).is_at_least(1)
  end
end
