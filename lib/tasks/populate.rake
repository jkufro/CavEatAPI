namespace :db do
  desc "Erase and fill database with USDA data (except users)"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    require 'csv'
    require 'set'

    # clear out tables
    puts 'Deleting all table contents (except users)...'
    Food.delete_all
    NutritionFact.delete_all
    FoodIngredient.delete_all
    Ingredient.delete_all
    Nutrient.delete_all
    puts "Deleted.\n\n"

    # set file paths
    nutrient_file_path = 'lib/data/trimmed/nutrient.csv'
    branded_food_file_path = 'lib/data/trimmed/branded_food.csv'
    food_file_path = 'lib/data/trimmed/food.csv'
    food_nutrient_file_path = 'lib/data/trimmed/food_nutrient.csv'

    if Rails.env == 'production' || ENV['USE_FULL'] == 'true'
      # nutrient_file_path = 'lib/data/full/nutrient.csv'
      branded_food_file_path = 'lib/data/full/branded_food.csv'
      food_file_path = 'lib/data/full/food.csv'
      food_nutrient_file_path = 'lib/data/full/food_nutrient.csv'
    end

    def load_nutrients(nutrient_file_path)
      id_col = 0
      name_col = 1
      unit_col = 2
      alias_col = 5
      description_col = 6
      source_col = 7
      is_limiting_col = 8
      sorting_order_col = 9

      puts "Adding Nutrients to database from #{nutrient_file_path}..."
      File.open(nutrient_file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        while row = csv.shift
          if !Nutrient.find_by_id(row[id_col])
            Nutrient.create(
              id: row[id_col],
              name: row[name_col],
              alias: row[alias_col],
              description: row[description_col],
              source: row[source_col],
              unit: row[unit_col].downcase,
              is_limiting: row[is_limiting_col] || false,
              sorting_order: row[sorting_order_col]
            )
          end
        end
      end
      puts "Done adding Nutrients.\n\n"
    end


    def get_nutrient_factor(row)
      serving_size_col = 4
      serving_size_unit_col = 5
      if row[serving_size_unit_col] == "g"
        return Float(row[serving_size_col]) / 100  # all nutrition facts based on 100g
      else  # could be 'g' or 'ml'
        return 1
      end
    end


    def get_foods(branded_food_file_path)
      all_foods = Hash.new(nil)
      all_food_ingredients = []
      all_ingredients = Hash.new(nil)
      food_nutrient_factors = Hash.new(1)
      num_foods = 0
      start_time = Time.now

      id_col = 0
      upc_col = 2
      ingredients_col = 3

      ingredient_id_counter = 1  # manually give ingredients an id
      batch_size = 10000

      puts "Parsing Foods and Ingredients from #{branded_food_file_path}..."
      File.open(branded_food_file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        while row = csv.shift
          food_nutrient_factors[row[id_col]] = get_nutrient_factor(row)

          food = Food.new(
            id: row[id_col],
            upc: row[upc_col],
            name: 'Unnamed Food'
          )

          ingredients = FoodService.get_tentative_ingredients_from_string(row[ingredients_col])
          ingredients.each do |ingredient|
            # Check if the ingredient already exists
            already_existing_ingredient = all_ingredients[ingredient]  # check the Set
            if already_existing_ingredient
              ingredient = already_existing_ingredient
            else
              ingredient.id = ingredient_id_counter
              ingredient_id_counter += 1
              all_ingredients[ingredient] = ingredient
            end

            # create the FoodIngredient
            all_food_ingredients << FoodIngredient.new(
              food_id: food.id,
              ingredient_id: ingredient.id
            )
          end

          all_foods[food.id] = food
          num_foods += 1
          if num_foods % batch_size == 0
            # Doing FoodIngredient imports in batches to reduce memory usage and avoid huge slowdowns
            FoodIngredient.import [:food_id, :ingredient_id], all_food_ingredients, validate: false
            all_food_ingredients = []
            puts "\t#{num_foods} foods read in #{(Time.now - start_time).round(2)} seconds"
          end
        end
      end
      FoodIngredient.import [:food_id, :ingredient_id], all_food_ingredients, validate: false

      puts "Done parsing Foods and Ingredients.\n\n"
      return [all_foods, all_ingredients, food_nutrient_factors]
    end


    def update_food_names(food_file_path, all_foods)
      id_col = 0
      name_col = 2

      puts "Parsing and updating Food names from #{food_file_path}..."
      File.open(food_file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        start_time = Time.now
        num_foods = 0

        while row = csv.shift
          food = all_foods[row[id_col].to_i]
          food.name = row[name_col] if food
          num_foods += 1
          puts "\t#{num_foods} Food names read in #{(Time.now - start_time).round(2)} seconds" if num_foods % 10000 == 0
        end
      end
      puts "Done updating Food names.\n\n"
    end


    def import_nutrition_facts(food_nutrient_file_path, food_nutrient_factors)
      batch_nutrition_facts = []

      id_col = 0
      food_id_col = 1
      nutrient_id_col = 2
      amount_col = 3

      start_time = Time.now
      num_facts = 0
      batch_size = 10000

      puts "Parsing and importing Nutrition Facts from #{food_nutrient_file_path}..."
      File.open(food_nutrient_file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        while row = csv.shift
          amount = (food_nutrient_factors[row[food_id_col]] * Float(row[amount_col])).round(2)
          amount = amount.round if amount % 1 >= 0.9 || amount % 1 <= 0.1

          batch_nutrition_facts << NutritionFact.new(
            id: row[id_col],
            food_id: row[food_id_col],
            nutrient_id: row[nutrient_id_col],
            amount: amount,
          )
          num_facts += 1
          if num_facts % batch_size == 0
            NutritionFact.import batch_nutrition_facts, validate: false
            batch_nutrition_facts = []
            puts "\t#{num_facts} Nutrition Facts Imported in #{(Time.now - start_time).round(2)} seconds"
          end
        end

        NutritionFact.import [:id, :food_id, :nutrient_id, :amount], batch_nutrition_facts, validate: false
        batch_nutrition_facts = []
      end

      puts "Done importing Nutrition Facts.\n\n"
    end


    script_start_time = Time.now

    load_nutrients(nutrient_file_path)
    result = get_foods(branded_food_file_path)
    all_foods, all_ingredients, food_nutrient_factors = result[0], result[1], result[2]
    update_food_names(food_file_path, all_foods)
    result = nil

    puts 'Importing all Food and Ingredient records...'
    import_start_time = Time.now
    Ingredient.import [:id, :name, :composition, :is_warning], all_ingredients.keys, validate: false, batch_size: 10000
    all_ingredients = nil
    puts "\tImported Ingredients."
    Food.import [:id, :upc, :name], all_foods.values, validate: false, batch_size: 10000
    all_foods = nil
    puts "\tImported Foods."
    puts "Imported all Foods and Ingredients in #{Time.now - import_start_time} seconds\n\n"

    import_nutrition_facts(food_nutrient_file_path, food_nutrient_factors)

    puts "Database populated in #{Time.now - script_start_time}"
  end
end
