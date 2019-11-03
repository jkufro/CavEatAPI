require 'test_helper'

class StringRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user_one
  end

  teardown do
    logout
  end

  should 'get index' do
    get string_requests_path
    assert_response :success
  end

  should 'get show' do
    get string_request_path(string_requests(:one).id)
    assert_response :success
  end
end
