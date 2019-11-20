require 'test_helper'
require 'set'

class FoodServiceTest < ActiveSupport::TestCase
  context 'tentative ingredients' do
    should 'show that get_tentative_ingredients_from_string works' do
      num_fixtures = 76
      strategy = 's2_solutions'
      (1..num_fixtures).each do |num|
        input_file = file_fixture("ingredient_listings/%02d.txt" % num).read
        output_file = file_fixture("ingredient_listings/#{strategy}/%02d.txt" % num).read
        expected_output = Set.new(output_file.split("\n").map(&:capitalize_first_letters))
        output = Set.new(FoodService.get_tentative_ingredients_from_string(input_file).map(&:name))
        byebug unless expected_output == output
        assert_equal expected_output, output
      end
    end
  end

  # context 'basic tests' do
  #   should 'get ingredients_from_string' do
  #     ingredients_string = "ingredient one\n (Composition for ingredient one.), Ingredient Two [Composition For Ingredient Two.]"
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 2, ingredients.size
  #   end

  #   should 'get nutrition_facts_from_string' do
  #     nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtein 20g\n"
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 2, nutrition_facts.size
  #     assert_equal nutrients(:added_sugars).common_name, nutrition_facts.first.common_name
  #     assert_equal 5, nutrition_facts.first.amount.to_i
  #     assert_equal nutrients(:protein).common_name, nutrition_facts.second.common_name
  #     assert_equal 20, nutrition_facts.second.amount.to_i
  #   end

  #   should 'get food_from_strings' do
  #     upc = 6612381239
  #     nutrition_facts_string = "\nAdded Sugars\n 5gother extraneous textProtein 20g\n"
  #     ingredients_string = "ingredient one\n (Composition for ingredient one.), Ingredient Two [Composition For Ingredient Two.]"
  #     food = FoodService.food_from_strings(upc, nutrition_facts_string, ingredients_string)
  #     assert_equal 2, food.nutrition_facts.size
  #     assert_equal 2, food.ingredients.size
  #     assert_equal 'Unnamed Food', food.name
  #     assert_equal upc, food.upc
  #   end

  #   should 'get_tentative_ingredients_from_string' do
  #     input = ''
  #     assert_equal 0, FoodService.get_tentative_ingredients_from_string(input).size

  #     input = '.'
  #     assert_equal 0, FoodService.get_tentative_ingredients_from_string(input).size

  #     input = 'LIGHT TUNA, WATER, VEGETABLE BROTH (SOY), SALT. '
  #     assert_equal 4, FoodService.get_tentative_ingredients_from_string(input).size

  #     input = 'PASTEURIZED MILK, SALT, ENZYMES, CHEESE CULTURES (LACTIC STARTER, SOY PROTEIN). '
  #     assert_equal 4, FoodService.get_tentative_ingredients_from_string(input).size

  #     input = '(GLUTEN-FREE, NON-GMO): VEGENAISE* (SOYBEAN OIL*, FILTERED WATER, BROWN RICE SYRUP*, APPLE CIDER VINEGAR*, SOY PROTEIN*, SEA SALT, MUSTARD FLOUR*, LEMON JUICE CONCENTRATE*), FILTERED WATER, FRESH CULTURE BUTTERMILK*, WHITE VINEGAR*, SOUR CREAM* (CULTURED PASTEURIZED NONFAT MILK*, PASTEURIZED CREAM*, ACIDOPHILUS AND BIFIDUS CULTURES, MICROBIAL ENZYME), SEA SALT, GARLIC*, XANTHAN GUM, ONION*, SPICES*, NATURAL FLAVOR, MUSTARD FLOUR*.'
  #     assert_equal 12, FoodService.get_tentative_ingredients_from_string(input).size
  #   end
  # end

  # def assert_has_ingredients(expected, result)
  #   assert_equal Set.new(expected), Set.new(result)
  # end

  # def assert_has_nutrition_facts(expected, result)
  #   assert_equal Set.new(expected.map(&:first)), Set.new(result.map(&:nutrient))
  #   expected_hash = {}
  #   result_hash = {}
  #   result.each { |r| result_hash[r.common_name] = r }
  #   expected.each { |e| expected_hash[e.first.common_name] = e.second }
  #   expected_hash.each do |key, value|
  #     assert_equal value, result_hash[key].amount
  #   end
  # end

  # context 'complex tests' do
  #   setup do
  #     @total_fat = Nutrient.create(name: 'Total Fat', unit: 'g', description: '', is_limiting: false)
  #     @sat_fat = Nutrient.create(name: 'Saturated Fat', unit: 'g', description: '', is_limiting: true)
  #     @short_sat_fat = Nutrient.create(name: 'Sat Fat', unit: 'g', description: '', is_limiting: true)
  #     @trans_fat = Nutrient.create(name: 'Trans Fat', unit: 'g', description: '', is_limiting: true)
  #     @poly_fat = Nutrient.create(name: 'Polyunsaturated Fat', unit: 'g', description: '', is_limiting: false)
  #     @mono_fat = Nutrient.create(name: 'Monounsaturated Fat', unit: 'g', description: '', is_limiting: false)
  #     @cholesterol = Nutrient.create(name: 'Cholesterol', unit: 'mg', description: '', is_limiting: false)
  #     @short_cholesterol = Nutrient.create(name: 'Cholest.', unit: 'mg', description: '', is_limiting: false)
  #     @sodium = Nutrient.create(name: 'Sodium', unit: 'mg', description: '', is_limiting: false)
  #     @potassium = Nutrient.create(name: 'Potassium', unit: 'mg', description: '', is_limiting: false)
  #     @carbs = Nutrient.create(name: 'Total Carbohydrate', unit: 'g', description: '', is_limiting: false)
  #     @short_carbs = Nutrient.create(name: 'Total Carb.', unit: 'g', description: '', is_limiting: false)
  #     @fiber = Nutrient.create(name: 'Dietary Fiber', unit: 'g', description: '', is_limiting: false)
  #     @sugars = Nutrient.create(name: 'Sugars', unit: 'g', description: '', is_limiting: false)

  #     @cult_cream = Ingredient.create(name: 'Cultured Cream', composition: '')
  #     @wheat = Ingredient.create(name: 'Enriched Wheat Flour', composition: '(Flour, Niacin, Reduced Iron, Thiamin Mononitrate, Riboflavin, Folic Acid)')
  #     @sugar = Ingredient.create(name: 'Sugar', composition: '')
  #     @salt = Ingredient.create(name: 'Salt', composition: '')
  #     @syrup = Ingredient.create(name: 'Malt Syrup', composition: '(Tapioca Syrup, Malt Extract)')
  #     @soda = Ingredient.create(name: 'Soda', composition: '')
  #     @chicpeas = Ingredient.create(name: 'Organic Fresh Steamed Chickpeas', composition: '')
  #     @water = Ingredient.create(name: 'Water', composition: '')
  #     @sesame = Ingredient.create(name: 'Organic Sesame Tahini', composition: '')
  #     @oils = Ingredient.create(name: 'Blend of Oils', composition: '(Organic Sunflower Oil, Organic Extra Virgin Olive Oil)')
  #     @sea_salt = Ingredient.create(name: 'Sea Salt', composition: '')
  #     @garlic = Ingredient.create(name: 'Organic Garlic', composition: '')
  #     @citric = Ingredient.create(name: 'Citric Acid', composition: '')
  #     @cumin = Ingredient.create(name: 'Organic Cumin', composition: '')
  #     @guar = Ingredient.create(name: 'Organic Guar Gunt', composition: '')
  #     @almond_milk = Ingredient.create(name: 'Almondmilk', composition: '(Filtered Water, Almonds)')
  #     @ca_carb = Ingredient.create(name: 'Calcium Carbonate', composition: '')
  #     @nat_flavor = Ingredient.create(name: 'Natural Flavors', composition: '')
  #     @pot_cit = Ingredient.create(name: 'Potassium Citrate', composition: '')
  #     @sunflower = Ingredient.create(name: 'Sunflower Lecithin', composition: '')
  #     @gellan = Ingredient.create(name: 'Gellan Gum', composition: '')
  #     @vit_a = Ingredient.create(name: 'Vitamin A Palmitate', composition: '')
  #     @vit_d2 = Ingredient.create(name: 'Vitamin D2', composition: '')
  #     @d_alpha = Ingredient.create(name: 'D-ALPHA-TOCOPHEROL', composition: '(Natural Vitamin E)')
  #   end

  #   teardown do
  #     @total_fat.delete
  #     @sat_fat.delete
  #     @trans_fat.delete
  #     @poly_fat.delete
  #     @mono_fat.delete
  #     @cholesterol.delete
  #     @sodium.delete
  #     @potassium.delete
  #     @carbs.delete
  #     @short_carbs.delete
  #     @fiber.delete
  #     @sugars.delete

  #     @cult_cream.delete
  #     @wheat.delete
  #     @sugar.delete
  #     @salt.delete
  #     @syrup.delete
  #     @soda.delete
  #     @chicpeas.delete
  #     @water.delete
  #     @sesame.delete
  #     @oils.delete
  #     @sea_salt.delete
  #     @garlic.delete
  #     @citric.delete
  #     @cumin.delete
  #     @guar.delete
  #     @almond_milk.delete
  #     @ca_carb.delete
  #     @nat_flavor.delete
  #     @pot_cit.delete
  #     @sunflower.delete
  #     @gellan.delete
  #     @vit_a.delete
  #     @vit_d2.delete
  #     @d_alpha.delete
  #   end

  #   should 'get ingredients_from_string' do
  #     ingredients_string = file_fixture('ingredients_scan_1.txt').read
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 5, ingredients.size
  #     assert_has_ingredients(
  #       [
  #         @wheat,
  #         @sugar,
  #         @salt,
  #         @syrup,
  #         @soda
  #       ],
  #       ingredients
  #     )

  #     ingredients_string = file_fixture('ingredients_scan_2.txt').read
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 1, ingredients.size
  #     assert_has_ingredients(
  #       [
  #         @cult_cream
  #       ],
  #       ingredients
  #     )

  #     ingredients_string = file_fixture('ingredients_scan_3.txt').read
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 9, ingredients.size
  #     assert_has_ingredients(
  #       [
  #         @chicpeas,
  #         @water,
  #         @sesame,
  #         @oils,
  #         @sea_salt,
  #         @garlic,
  #         @citric,
  #         @cumin,
  #         @guar
  #       ],
  #       ingredients
  #     )

  #     ingredients_string = file_fixture('ingredients_scan_4.txt').read
  #     ingredients = FoodService.ingredients_from_string(ingredients_string)
  #     assert_equal 10, ingredients.size
  #     assert_has_ingredients(
  #       [
  #         @almond_milk,
  #         @ca_carb,
  #         @nat_flavor,
  #         @sea_salt,
  #         @pot_cit,
  #         @sunflower,
  #         @gellan,
  #         @vit_a,
  #         @vit_d2,
  #         @d_alpha
  #       ],
  #       ingredients
  #     )
  #   end

  #   should 'get nutrition_facts_from_string' do
  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_1.txt').read
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 11, nutrition_facts.size
  #     assert_has_nutrition_facts(
  #       [
  #         [@total_fat, 0],
  #         [@sat_fat, 0],
  #         [@trans_fat, 0],
  #         [@poly_fat, 0],
  #         [@mono_fat, 0],
  #         [@cholesterol, 0],
  #         [@sodium, 330],
  #         [@carbs, 24],
  #         [@fiber, 1],
  #         [@sugars, 2],
  #         [nutrients(:protein), 2]
  #       ],
  #       nutrition_facts
  #     )

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_2.txt').read
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 9, nutrition_facts.size
  #     assert_has_nutrition_facts(
  #       [
  #         [@total_fat, 5],
  #         [@sat_fat, 3.5],
  #         [@trans_fat, 0],
  #         [@cholesterol, 20],
  #         [@sodium, 15],
  #         [@carbs, 1],
  #         [@fiber, 0],
  #         [@sugars, 1],
  #         [nutrients(:protein), 1]
  #       ],
  #       nutrition_facts
  #     )

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_3.txt').read
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 7, nutrition_facts.size
  #     assert_has_nutrition_facts(
  #       [
  #         [@short_sat_fat, 1],
  #         [@trans_fat, 0],
  #         [@short_cholesterol, 0],
  #         [@sodium, 110],
  #         [@short_carbs, 3],
  #         [@sugars, 0],
  #         [nutrients(:protein), 2]
  #       ],
  #       nutrition_facts
  #     )

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_4.txt').read
  #     nutrition_facts = FoodService.nutrition_facts_from_string(nutrition_facts_string)
  #     assert_equal 12, nutrition_facts.size
  #     assert_has_nutrition_facts(
  #       [
  #         [@total_fat, 2.5],
  #         [@sat_fat, 0],
  #         [@trans_fat, 0],
  #         [@poly_fat, 0.5],
  #         [@mono_fat, 1.5],
  #         [@cholesterol, 0],
  #         [@sodium, 170],
  #         [@potassium, 160],
  #         [@carbs, 1],
  #         [@fiber, 1],
  #         [@sugars, 0],
  #         [nutrients(:protein), 1]
  #       ],
  #       nutrition_facts
  #     )
  #   end

  #   should 'get food_from_strings' do
  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_1.txt').read
  #     ingredients_string = file_fixture('ingredients_scan_1.txt').read
  #     result = FoodService.food_from_strings(42, nutrition_facts_string, ingredients_string)
  #     assert_equal 42, result.upc
  #     assert_equal 11, result.nutrition_facts.size
  #     assert_equal 5, result.ingredients.size

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_2.txt').read
  #     ingredients_string = file_fixture('ingredients_scan_2.txt').read
  #     result = FoodService.food_from_strings(43, nutrition_facts_string, ingredients_string)
  #     assert_equal 43, result.upc
  #     assert_equal 9, result.nutrition_facts.size
  #     assert_equal 1, result.ingredients.size

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_3.txt').read
  #     ingredients_string = file_fixture('ingredients_scan_3.txt').read
  #     result = FoodService.food_from_strings(44, nutrition_facts_string, ingredients_string)
  #     assert_equal 44, result.upc
  #     assert_equal 7, result.nutrition_facts.size
  #     assert_equal 9, result.ingredients.size

  #     nutrition_facts_string = file_fixture('nutrition_facts_scan_4.txt').read
  #     ingredients_string = file_fixture('ingredients_scan_4.txt').read
  #     result = FoodService.food_from_strings(45, nutrition_facts_string, ingredients_string)
  #     assert_equal 45, result.upc
  #     assert_equal 12, result.nutrition_facts.size
  #     assert_equal 10, result.ingredients.size
  #   end
  # end
end
