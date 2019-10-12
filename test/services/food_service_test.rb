require 'test_helper'

class FoodServiceTest < ActiveSupport::TestCase
  should 'get ingredients_from_string' do
    ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
    ingredients = FoodService.ingredients_from_string(ingredients_string)
    assert_equal 2, ingredients.size
  end

  should 'get food_from_strings' do
    upc = 6612381239
    nutrition_facts_string = ''
    ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
    food = FoodService.food_from_strings(upc, nutrition_facts_string, ingredients_string)
    assert_equal 0, food.nutrition_facts.size
    assert_equal 2, food.ingredients.size
    assert_equal 'Unnamed Food', food.name
    assert_equal upc, food.upc
  end
end
