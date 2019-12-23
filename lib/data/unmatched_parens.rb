# This script is used to extract a specific set of foods from the full UDSA dataset
# located in the /lib/data/full/ directory and export to the /lib/data/trimmed/ directory
#
# To run, you need to be in the /lib/data/ directory and run `ruby data_trimmer.rb`

require 'csv'
require 'set'

branded_food_file_path = 'lib/data/trimmed/branded_food.csv'
if ENV['USE_FULL'] == 'true'
  branded_food_file_path = 'lib/data/full/branded_food.csv'
end
export_file_path = 'lib/data/full/unmatched_parens_food_ids.txt'

def get_food_ids_with_unmatched_parens(branded_food_file_path)
  unmatched_parens = []
  start_time = Time.now

  id_col = 0
  ingredients_col = 3

  puts "Parsing Foods and Ingredients from #{branded_food_file_path}..."
  File.open(branded_food_file_path, 'r') do |file|
    csv = CSV.new(file, headers: true)

    while row = csv.shift
      unless do_parens_match(row[ingredients_col])
        unmatched_parens << row[id_col]
      end
    end
  end

  puts "Found #{unmatched_parens.size} foods with unmatched parentheses\n\n"
  return unmatched_parens
end

def do_parens_match(ingredients_string)
  open_paren, close_paren, open_square, close_square, open_curly, close_curly = 0, 0, 0, 0, 0, 0
  ingredients_string.split('').each do |c|
    open_paren += 1 if c == '('
    close_paren += 1 if c == ')'
    open_square += 1 if c == '['
    close_square += 1 if c == ']'
    open_curly += 1 if c == '{'
    close_curly += 1 if c == '}'
  end
  return open_paren == close_paren && open_square == close_square && open_curly == close_curly
end

ids = get_food_ids_with_unmatched_parens(branded_food_file_path)
File.open(export_file_path, "w+") do |file|
  file.puts(ids)
end
