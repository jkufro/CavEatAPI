require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'basic validations' do
    should validate_uniqueness_of(:username)
  end
end
