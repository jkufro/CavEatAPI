require 'test_helper'

class ApidocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user_one
  end

  teardown do
    # special case because of `No route matches [GET] "/api-docs/logout"` error
    get '/logout'
  end

  should 'get ui index' do
    get swagger_ui_engine_path
    assert_redirected_to 'http://www.example.com/api-docs/swagger_docs/v1'

    get 'http://www.example.com/api-docs/swagger_docs/v1'
    assert_response :success
  end

  should 'get json index' do
    get apidocs_path
    assert_response :success
  end
end
