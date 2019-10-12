require 'test_helper'

class FoodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user_one
  end

  teardown do
    logout
  end

  should 'get index' do
    get foods_path
    assert_response :success
  end

  should 'get show' do
    get food_path(foods(:food_one).id)
    assert_response :success
  end

  should 'get edit' do
    get edit_food_path(foods(:food_one).id)
    assert_response :success
  end

  should 'successfully edit' do
    patch food_path(foods(:food_one).id), params: { food: { name: "New Name", upc: 1234567890 } }
    assert_redirected_to food_path(foods(:food_one).id)
  end

  should 'fail edit' do
    patch food_path(foods(:food_one).id), params: { food: { name: "food_two", upc: nil } }
    assert_template :edit
  end

  should 'destroy' do
    assert_difference('Food.count', -1) do
      delete food_path(foods(:food_one).id)
    end

    assert_redirected_to foods_path
  end
end
