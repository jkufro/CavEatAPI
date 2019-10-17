require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  should 'get login' do
    get new_session_path
    assert_response :success
  end

  should 'successfully login' do
    post sessions_path, params: { username: users(:user_one).username, password: 'secret' }
    assert_redirected_to :foods
  end

  should 'fail login' do
    post sessions_path, params: { username: users(:user_one).username, password: '' }
    assert_template :new
  end

  should 'logout' do
    login_user_one

    get logout_path
    assert_equal I18n.t('sessions.destroy.success'), flash[:notice]
    assert_redirected_to new_session_path

    logout
  end
end
