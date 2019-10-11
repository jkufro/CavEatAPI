require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  should 'get index' do
    get ingredients_path
    assert_response :success
  end

  should 'get show' do
    get ingredient_path(ingredients(:ingredient_one).id)
    assert_response :success
  end

  should 'get edit' do
    get edit_ingredient_path(ingredients(:ingredient_one).id)
    assert_response :success
  end

  should 'successfully edit' do
    patch ingredient_path(ingredients(:ingredient_one).id), params: { ingredient: { name: "New Name", composition: '', description: '', is_warning: false } }
    assert_redirected_to ingredient_path(ingredients(:ingredient_one).id)
  end

  should 'fail edit' do
    patch ingredient_path(ingredients(:ingredient_one).id), params: { ingredient: { name: nil, composition: '', description: '', is_warning: false } }
    assert_template :edit
  end

  should 'destroy' do
    assert_difference('Ingredient.count', -1) do
      delete ingredient_path(ingredients(:ingredient_one).id)
    end

    assert_redirected_to ingredients_path
  end
end
