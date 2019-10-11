require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:food_ingredients)
    should have_many(:foods).through(:food_ingredients)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name).scoped_to(:description)
  end

  context 'scopes' do
    should 'show that search by name works' do
      search = Ingredient.all.search('')
      assert_equal 2, search.size

      search = Ingredient.all.search('ingredient')
      assert_equal 2, search.size

      search = Ingredient.all.search(ingredients(:ingredient_one).name)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_one).name, search.first.name

      search = Ingredient.all.search(ingredients(:ingredient_two).name)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_two).name, search.first.name
    end

    should 'show that search by description works' do
      search = Ingredient.all.search('')
      assert_equal 2, search.size

      search = Ingredient.all.search('Description for ')
      assert_equal 2, search.size

      search = Ingredient.all.search(ingredients(:ingredient_one).description)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_one).description, search.first.description

      search = Ingredient.all.search(ingredients(:ingredient_two).description)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_two).description, search.first.description
    end
  end
end
