require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user_one
  end

  teardown do
    logout
  end

  should 'get index' do
    get ingredients_path
    assert_response :success
  end

  should 'bulk update' do
    post bulk_update_ingredients_path, params: {
      ingredient: { description: 'foobar', is_warning: true }
    }
    assert_equal I18n.t('ingredients.bulk_update.success', succeeded: ingredients.size), flash[:success]
    assert_redirected_to ingredients_path

    ingredients.each do |ingredient|
      ingredient.reload
      assert_equal 'foobar', ingredient.description
      assert ingredient.is_warning
    end
  end

  should 'bulk update with search' do
    post bulk_update_ingredients_path, params: {
      search: 'ingredient_one',
      ingredient: { description: 'foobar', is_warning: false }
    }
    assert_equal I18n.t('ingredients.bulk_update.success', succeeded: 1), flash[:success]
    assert_redirected_to ingredients_path(search: 'ingredient_one')

    ingredients.each(&:reload)
    assert_not ingredients(:ingredient_one).is_warning
    assert_equal 'foobar', ingredients(:ingredient_one).description
    assert_not ingredients(:ingredient_two).is_warning
  end

  should 'fail bulk update' do
    # force an invalid ingredient so the bulk update fails on one
    ingredients(:ingredient_two).update_attribute(:name, nil)

    post bulk_update_ingredients_path, params: {
      ingredient: { description: '', is_warning: true }
    }
    assert_equal I18n.t('ingredients.bulk_update.warning', succeeded: 1, failed: 1), flash[:warning]
    assert_redirected_to ingredients_path

    ingredients.each(&:reload)
    assert ingredients(:ingredient_one).is_warning
    assert_not ingredients(:ingredient_two).is_warning
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
