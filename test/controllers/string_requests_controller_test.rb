require 'test_helper'

class StringRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get string_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get string_requests_show_url
    assert_response :success
  end

end
