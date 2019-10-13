require 'test_helper'

class FoodServiceTest < ActiveSupport::TestCase
  # context 'basic tests' do
  #   should 'get ingredients_from_string' do
  #     ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 2, ingredients.size
  #   end

  #   should 'get nutrition_facts_from_string' do
  #     nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtien 20g\n"
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 2, nutrition_facts.size
  #     assert_equal nutrients(:added_sugars).name, nutrition_facts.first.name
  #     assert_equal 5, nutrition_facts.first.amount.to_i
  #     assert_equal nutrients(:protien).name, nutrition_facts.second.name
  #     assert_equal 20, nutrition_facts.second.amount.to_i
  #   end

  #   should 'get food_from_strings' do
  #     upc = 6612381239
  #     nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtien 20g\n"
  #     ingredients_string = "ingredient_one\n (Composition for ingredient_one.), Ingredient Two [Composition For Ingredient Two.]"
  #     food = FoodService.food_from_strings(upc, nutrition_facts_string, ingredients_string)
  #     assert_equal 2, food.nutrition_facts.size
  #     assert_equal 2, food.ingredients.size
  #     assert_equal 'Unnamed Food', food.name
  #     assert_equal upc, food.upc
  #   end
  # end

  context 'complex tests' do
    setup do
      @total_fat = Nutrient.create(name: 'Total Fat', unit: 'g', description: '', is_limiting: false)
      @sat_fat = Nutrient.create(name: 'Saturated Fat', unit: 'g', description: '', is_limiting: true)
      @short_sat_fat = Nutrient.create(name: 'Sat Fat', unit: 'g', description: '', is_limiting: true)
      @trans_fat = Nutrient.create(name: 'Trans Fat', unit: 'g', description: '', is_limiting: true)
      @poly_fat = Nutrient.create(name: 'Polyunsaturated Fat', unit: 'g', description: '', is_limiting: false)
      @mono_fat = Nutrient.create(name: 'Monounsaturated Fat', unit: 'g', description: '', is_limiting: false)
      @cholesterol = Nutrient.create(name: 'Cholesterol', unit: 'mg', description: '', is_limiting: false)
      @short_cholesterol = Nutrient.create(name: 'Cholest.', unit: 'mg', description: '', is_limiting: false)
      @sodium = Nutrient.create(name: 'Sodium', unit: 'mg', description: '', is_limiting: false)
      @potassium = Nutrient.create(name: 'Potassium', unit: 'mg', description: '', is_limiting: false)
      @carbs = Nutrient.create(name: 'Total Carbohydrate', unit: 'g', description: '', is_limiting: false)
      @fiber = Nutrient.create(name: 'Dietary Fiber', unit: 'g', description: '', is_limiting: false)
      @sugars = Nutrient.create(name: 'Sugars', unit: 'g', description: '', is_limiting: false)
      @protien = Nutrient.create(name: 'Protein', unit: 'g', description: '', is_limiting: false)

      @cult_cream = Ingredient.create(name: 'Cultured Cream', composition: '')
      @wheat = Ingredient.create(name: 'Enriched Wheat Flour', composition: '(Flour, Niacin, Reduced Iron, Thiamin Mononitrate, Riboflavin, Folic Acid)')
      @sugar = Ingredient.create(name: 'Sugar', composition: '')
      @salt = Ingredient.create(name: 'Salt', composition: '')
      @syrup = Ingredient.create(name: 'Malt Syrup', composition: '(Tapioca Syrup, Malt Extract)')
      @soda = Ingredient.create(name: 'Soda', composition: '')
      @chicpeas = Ingredient.create(name: 'Organic Fresh Steamed Chickpeas', composition: '')
      @water = Ingredient.create(name: 'Water', composition: '')
      @sesame = Ingredient.create(name: 'Organic Sesame Tahini', composition: '')
      @oils = Ingredient.create(name: 'Blend of Oils', composition: '(Organic Sunflower Oil, Organic Extra Virgin Olive Oil)')
      @sea_salt = Ingredient.create(name: 'Sea Salt', composition: '')
      @garlic = Ingredient.create(name: 'Organic Garlic', composition: '')
      @citric = Ingredient.create(name: 'Citric Acid', composition: '')
      @cumin = Ingredient.create(name: 'Organic Cumin', composition: '')
      @guar = Ingredient.create(name: 'Organic Guar Gunt', composition: '')
      @almond_milk = Ingredient.create(name: 'Almondmilk', composition: '(Filtered Water, Almonds)')
      @ca_carb = Ingredient.create(name: 'Calcium Carbonate', composition: '')
      @nat_flavor = Ingredient.create(name: 'Natural Flavors', composition: '')
      @pot_cit = Ingredient.create(name: 'Potassium Citrate', composition: '')
      @sunflower = Ingredient.create(name: 'Sunflower Lecithin', composition: '')
      @gellan = Ingredient.create(name: 'Gellan Gum', composition: '')
      @vit_a = Ingredient.create(name: 'Vitamin A Palmitate', composition: '')
      @vit_d2 = Ingredient.create(name: 'Vitamin D2', composition: '')
      @d_alpha = Ingredient.create(name: 'D Alpha Tocopherol', composition: '(Natural Vitamin E)')
    end

    teardown do
      @total_fat.delete
      @sat_fat.delete
      @trans_fat.delete
      @poly_fat.delete
      @mono_fat.delete
      @cholesterol.delete
      @sodium.delete
      @potassium.delete
      @carbs.delete
      @fiber.delete
      @sugars.delete
      @protien.delete

      @cult_cream.delete
      @wheat.delete
      @sugar.delete
      @salt.delete
      @syrup.delete
      @soda.delete
      @chicpeas.delete
      @water.delete
      @sesame.delete
      @oils.delete
      @sea_salt.delete
      @garlic.delete
      @citric.delete
      @cumin.delete
      @guar.delete
      @almond_milk.delete
      @ca_carb.delete
      @nat_flavor.delete
      @pot_cit.delete
      @sunflower.delete
      @gellan.delete
      @vit_a.delete
      @vit_d2.delete
      @d_alpha.delete
    end

    should 'get ingredients_from_string' do
      ingredients_string = file_fixture('ingredients_scan_1.txt').read
      ingredients = FoodService.ingredients_from_string(ingredients_string)
      assert_equal 5, ingredients.size

      ingredients_string = file_fixture('ingredients_scan_2.txt').read
      ingredients = FoodService.ingredients_from_string(ingredients_string)
      assert_equal 1, ingredients.size

      ingredients_string = file_fixture('ingredients_scan_3.txt').read
      ingredients = FoodService.ingredients_from_string(ingredients_string)
      assert_equal 9, ingredients.size

      ingredients_string = file_fixture('ingredients_scan_4.txt').read
      ingredients = FoodService.ingredients_from_string(ingredients_string)
      assert_equal 10, ingredients.size
    end

    should 'get nutrition_facts_from_string' do
      nutrition_facts_string = file_fixture('nutrition_facts_scan_1.txt').read
      nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
      assert_equal 11, nutrition_facts.size

      nutrition_facts_string = file_fixture('nutrition_facts_scan_2.txt').read
      nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
      assert_equal 9, nutrition_facts.size

      nutrition_facts_string = file_fixture('nutrition_facts_scan_3.txt').read
      nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
      assert_equal 6, nutrition_facts.size

      nutrition_facts_string = file_fixture('nutrition_facts_scan_4.txt').read
      nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
      assert_equal 12, nutrition_facts.size
    end

    should 'get food_from_strings' do
    end
  end
end
