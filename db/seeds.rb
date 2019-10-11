# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'set'

def load_nutrients
  file_path = 'lib/data/nutrient.csv'
  id_col = 0
  name_col = 1
  unit_col = 2

  puts "Reading #{file_path} as CSV..."
  nutrient_table = CSV.parse(File.read(file_path), headers: true)
  puts "Read in #{file_path.size} rows.\n"

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

load_nutrients()
