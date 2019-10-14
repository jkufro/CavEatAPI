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
      nutrient_file_path = 'lib/data/full/nutrient.csv'
      branded_food_file_path = 'lib/data/full/branded_food.csv'
      food_file_path = 'lib/data/full/food.csv'
      food_nutrient_file_path = 'lib/data/full/food_nutrient.csv'
    end

    def create_missing_nutritents
      puts 'Creating missing Nutrients...'
      Nutrient.create(
        name: 'Total Fat',
        unit: 'g',
        description: '',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Saturated Fat',
        unit: 'g',
        description: '',
        is_limiting: true
      )
      Nutrient.create(
        name: 'Trans Fat',
        unit: 'g',
        description: '',
        is_limiting: true
      )
      Nutrient.create(
        name: 'Polyunsaturated Fat',
        unit: '',
        description: '',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Monounsaturated Fat',
        unit: '',
        description: 'g',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Sodium',
        unit: 'mg',
        description: '',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Total Carbohydrate',
        unit: 'g',
        description: '',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Dietary Fiber',
        unit: 'g',
        description: '',
        is_limiting: false
      )
      Nutrient.create(
        name: 'Sugars',
        unit: 'g',
        description: '',
        is_limiting: false
      )
      puts "Done creating missing Nutrients.\n\n"
    end

    def load_nutrients(nutrient_file_path)
      id_col = 0
      name_col = 1
      unit_col = 2

      puts "Adding Nutrients to database from #{nutrient_file_path}..."
      File.open(nutrient_file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        while row = csv.shift
          if !Nutrient.find_by_id(row[id_col])
            Nutrient.create(
              id: row[id_col],
              name: row[name_col],
              description: nil,
              source: nil,
              unit: row[unit_col].downcase,
              is_limiting: false
            )
          end
        end
      end
      puts "Done adding Nutrients.\n\n"
    end


    def get_foods(branded_food_file_path)
      all_foods = Hash.new(nil)
      all_food_ingredients = []
      all_ingredients = Hash.new(nil)
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
      return [all_foods, all_ingredients]
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


    def import_nutrition_facts(food_nutrient_file_path)
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
          batch_nutrition_facts << NutritionFact.new(
            id: row[id_col],
            food_id: row[food_id_col],
            nutrient_id: row[nutrient_id_col],
            amount: row[amount_col],
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
    create_missing_nutritents()
    result = get_foods(branded_food_file_path)
    all_foods, all_ingredients = result[0], result[1]
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

    import_nutrition_facts(food_nutrient_file_path)

    puts "Database populated in #{Time.now - script_start_time}"
  end
end
