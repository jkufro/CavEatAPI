require 'test_helper'

class FoodServiceTest < ActiveSupport::TestCase
  context 'basic tests' do
    should 'get ingredients_from_string' do
      ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
      ingredients = FoodService.ingredients_from_string(ingredients_string)
      assert_equal 2, ingredients.size
    end

    should 'get nutrition_facts_from_string' do
      nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtien 20g\n"
      nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
      assert_equal 2, nutrition_facts.size
      assert_equal nutrients(:added_sugars).name, nutrition_facts.first.name
      assert_equal 5, nutrition_facts.first.amount.to_i
      assert_equal nutrients(:protien).name, nutrition_facts.second.name
      assert_equal 20, nutrition_facts.second.amount.to_i
    end

    should 'get food_from_strings' do
      upc = 6612381239
      nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtien 20g\n"
      ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
      food = FoodService.food_from_strings(upc, nutrition_facts_string, ingredients_string)
      assert_equal 2, food.nutrition_facts.size
      assert_equal 2, food.ingredients.size
      assert_equal 'Unnamed Food', food.name
      assert_equal upc, food.upc
    end
  end

  context 'compex tests' do
    setup do

    end

    teardown do

    end

    should 'get ingredients_from_string' do

    end

    should 'get nutrition_facts_from_string' do

    end

    should 'get food_from_strings' do

    end
  end
end
