require 'test_helper'

class NutrientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user_one
  end

  teardown do
    logout
  end

  should 'get index' do
    get nutrients_path
    assert_response :success
  end

  should 'get show' do
    get nutrient_path(nutrients(:added_sugars).id)
    assert_response :success
  end

  should 'get edit' do
    get edit_nutrient_path(nutrients(:added_sugars).id)
    assert_response :success
  end

  should 'successfully edit' do
    patch nutrient_path(nutrients(:added_sugars).id), params: { nutrient: { name: "New Name", description: '', unit: 'G', is_limiting: false } }
    assert_redirected_to nutrient_path(nutrients(:added_sugars).id)
  end

  should 'fail edit' do
    patch nutrient_path(nutrients(:added_sugars).id), params: { nutrient: { name: nil, description: '', unit: nil, is_limiting: false } }
    assert_template :edit
  end

  should 'destroy' do
    assert_difference('Nutrient.count', -1) do
      delete nutrient_path(nutrients(:added_sugars).id)
    end

    assert_redirected_to nutrients_path
  end
end
