# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# !!! investigate speed improvement
#       https://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby

require 'csv'
require 'set'

nutrient_file_path = 'lib/data/trimmed/nutrient.csv'
branded_food_file_path = 'lib/data/trimmed/branded_food.csv'
food_file_path = 'lib/data/trimmed/food.csv'
food_nutrient_file_path = 'lib/data/trimmed/food_nutrient.csv'

if Rails.env == 'production'
  nutrient_file_path = 'lib/data/full/nutrient.csv'
  branded_food_file_path = 'lib/data/full/branded_food.csv'
  food_file_path = 'lib/data/full/food.csv'
  food_nutrient_file_path = 'lib/data/full/food_nutrient.csv'
end


def load_nutrients(nutrient_file_path)
  id_col = 0
  name_col = 1
  unit_col = 2

  puts "Reading #{nutrient_file_path} as CSV..."
  nutrient_table = CSV.parse(File.read(nutrient_file_path), headers: true)
  puts "Read in #{nutrient_file_path.size} rows.\n"

  # Find unique ingredients
  puts 'Adding Nutrients to database...'
  nutrient_table.each do |row|
    if !Nutrient.find_by_id(row[id_col])
      nutrient = Nutrient.new(
        id: row[id_col],
        name: row[name_col],
        description: nil,
        unit: row[unit_col],
        is_limiting: false
      )
      nutrient.save if nutrient.valid?
    end
  end
  puts 'Done adding Nutrients.'
end


def load_foods(branded_food_file_path)
  id_col = 0
  upc_col = 2
  ingredients_col = 3

  puts "Reading #{branded_food_file_path} as CSV..."
  branded_food_table = CSV.parse(File.read(branded_food_file_path), headers: true)
  puts "Read in #{branded_food_file_path.size} rows.\n"

  # Find unique ingredients
  puts 'Adding Foods to database...'
  branded_food_table.each do |row|
    food = Food.new(
      id: row[id_col],
      upc: row[upc_col],
      name: 'Unnamed Food'
    )
    add_ingredients_from_string(food, row[ingredients_col]) if food.save
  end
  puts 'Done adding Foods.'
end


def add_ingredients_from_string(food, product_ingredients)
  # remove trailing '.' if exists
  product_ingredients.chop! if product_ingredients.end_with?('.')

  ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
  product_ingredients.split('').each do |c|
    if ingredient.size > 0 && open_paren == close_paren && open_square == close_square && open_curly == close_curly && c == ','
      ingredient.strip!
      ingredient.chop! while ingredient.end_with?('*')
      ingredient.sub!('*', '') while ingredient.start_with?('*')
      ingredient.strip!
      ingredient = ingredient.titleize
      create_ingredient_and_add_to_food(food, ingredient)
      ingredient, open_paren, close_paren, open_square, close_square, open_curly, close_curly = "", 0, 0, 0, 0, 0, 0
      next
    end
    open_paren += 1 if c == '('
    close_paren += 1 if c == ')'
    open_square += 1 if c == '['
    close_square += 1 if c == ']'
    open_curly += 1 if c == '{'
    close_curly += 1 if c == '}'
    ingredient += c
  end

  create_ingredient_and_add_to_food(food, ingredient)
end


def create_ingredient_and_add_to_food(food, ingredient_string)
  # split up the name and description based on first (, {, or [
  split_index = [ingredient_string.index('('), ingredient_string.index('{'), ingredient_string.index('[')].compact.min
  ingredient_name = split_index ? ingredient_string.slice(0, split_index) : ingredient_string
  ingredient_description = split_index ? ingredient_string.slice(split_index, ingredient_string.length + 1) : ''

  ingredient = Ingredient.new(
    name: ingredient_name,
    description: ingredient_description,
    is_warning: false
  )
  unless ingredient.save
    ingredient = Ingredient.by_name(ingredient_name).by_description(ingredient_description).first
    return unless ingredient
  end

  food_ingredient = FoodIngredient.new(
    food_id: food.id,
    ingredient_id: ingredient.id
  )
  food_ingredient.save
end


def update_food_names(food_file_path)
  id_col = 0
  name_col = 2

  puts "Reading #{food_file_path} as CSV..."
  food_table = CSV.parse(File.read(food_file_path), headers: true)
  puts "Read in #{food_file_path.size} rows.\n"

  puts 'Updating Food names in database...'
  food_table.each do |row|
    Food.where(id: row[id_col]).update(name: row[name_col].titleize)
  end
  puts 'Done updating food names.'
end

def load_nutrition_facts(food_nutrient_file_path)
  id_col = 0
  food_id_col = 1
  nutrient_id_col = 2
  amount_col = 3

  puts "Reading #{food_nutrient_file_path} as CSV..."
  food_nutrients_table = CSV.parse(File.read(food_nutrient_file_path), headers: true)
  puts "Read in #{food_nutrient_file_path.size} rows.\n"

  # Find unique ingredients
  puts 'Adding NutritionFacts to database...'
  food_nutrients_table.each do |row|
    nutrition_fact = NutritionFact.new(
      id: row[id_col],
      food_id: row[food_id_col],
      nutrient_id: row[nutrient_id_col],
      amount: row[amount_col],
    )
    nutrition_fact.save if nutrition_fact.valid?
  end
  puts 'Done adding NutritionFacts.'
end


load_nutrients(nutrient_file_path)
load_foods(branded_food_file_path)
load_nutrition_facts(food_nutrient_file_path)
update_food_names(food_file_path)
