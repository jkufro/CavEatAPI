require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  should 'get index' do
    get users_path
    assert_response :success
  end

  should 'get show' do
    get user_path(users(:user_one).id)
    assert_response :success
  end

  should 'get edit' do
    get edit_user_path(users(:user_one).id)
    assert_response :success
  end

  should 'get new' do
    get new_user_path
    assert_response :success
  end

  should 'successfully create' do
    post users_path, params: { user: { username: "My New User", password: 'secret', password_confirmation: 'secret' } }
    assert_redirected_to user_path(User.last.id)
  end

  should 'fail create' do
    post users_path, params: { user: { username: "New Name", password: 'secret', password_confirmation: '' } }
    assert_template :edit
  end

  should 'successfully edit' do
    patch user_path(users(:user_one).id), params: { user: { username: "user_one", password: 'secret1', password_confirmation: 'secret1' } }
    assert_redirected_to user_path(users(:user_one).id)
  end

  should 'fail edit' do
    patch user_path(users(:user_one).id), params: { user: { username: "", password: '', password_confirmation: '' } }
    assert_template :edit
  end

  should 'destroy' do
    assert_difference('User.count', -1) do
      delete user_path(users(:user_one).id)
    end

    assert_redirected_to users_path
  end
end
