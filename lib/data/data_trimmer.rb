# This script is used to extract a specific set of foods from the full UDSA dataset
# located in the /lib/data/full/ directory and export to the /lib/data/trimmed/ directory
#
# To run, you need to be in the /lib/data/ directory and run `ruby data_trimmer.rb`

require 'csv'
require 'set'

target_ids = Set.new([360337, 366352, 361405, 361928, 356492, 363201, 361849, 361596, 365531, 363684, 366705, 361881, 365276, 363542, 365695, 362812, 357057, 367048, 366155, 362291, 363979, 365777, 362640, 357895, 366043, 357352, 357093, 361126, 363083, 361919, 358277, 361358, 360332, 362193, 365676, 364542, 362671, 366586, 365546, 357403, 365709, 361891, 357884, 362294, 360685, 362736, 366424, 366525, 357764, 357781, 357795, 361127, 364793, 364386, 357153, 365099, 366891, 360374, 362709, 365504, 361728, 365870, 358234, 365351, 365990, 363603, 364318, 362278, 363129, 356654, 360363, 362596, 362414, 358214, 357605, 360973, 362299, 360946, 362143, 366209, 363087, 362545, 364958, 361726, 361561, 367492, 363462, 365836, 356704, 367226, 361485, 367497, 365532, 357261, 365690, 361950, 364750, 366938, 361889, 362822, 367444, 358163, 362609, 361739, 356782, 361042, 366481, 360436, 357887, 367218, 367661, 366010, 365337, 366716, 364889, 358419, 367459, 365187, 365496, 367968, 360587, 366945, 357241, 357401, 360761, 363931, 367277, 356765, 360958, 358106, 363351, 361056, 365019, 362852, 365135, 365889, 368082, 362517, 361903, 358489, 358260, 365629, 357030, 362305, 363652, 356542, 356743, 362906, 360758, 366340, 367178, 366681, 367662, 363535, 361876, 362376, 367284, 367380, 356945, 365028, 366274, 364465, 367729, 357865, 357766, 357402, 365662, 357022, 360730, 364002, 361985, 364053, 362763, 367248, 362022, 356941, 366855, 366219, 366680, 365923, 363581, 363140, 361309, 360492, 357445, 358105, 357233, 358011, 362388, 356685, 367880, 360400, 362295, 357543, 356619, 357070, 362257, 365186, 360649, 367018, 366800, 360465, 364109, 366032, 367546, 361818, 357595, 367416, 366742, 366922, 367045, 356966, 365673, 361242, 361267, 367054, 363244, 358076, 361034, 361433, 365545, 366533, 362316, 361114, 366050, 361705, 361146, 356464, 358507, 356864, 357283, 361551, 358269, 360833, 357051, 366272, 364988, 358431, 357537, 364444, 357083, 368043, 356636, 363340, 362645, 368063, 365039, 366767, 366222, 357794, 364969, 358472, 363730, 361926, 357461, 364379, 357790, 368069, 361317, 367859, 367804, 360505, 367917, 367146, 367096, 363442, 363012, 363822, 360689, 366915, 357211, 358107, 358030, 362421, 362134, 358028, 366107, 361747, 356431, 364610, 362253, 364996, 356902, 361262, 364550, 364530, 363642, 367896, 366697, 357496, 363079, 366367, 364645, 358045, 365053, 357270, 361350, 363846, 364792, 364685].map(&:to_s))

source_nutrient_file_path = 'full/nutrient.csv'
source_branded_food_file_path = 'full/branded_food.csv'
source_food_file_path = 'full/food.csv'
source_food_nutrient_file_path = 'full/food_nutrient.csv'

export_nutrient_file_path = 'trimmed/nutrient.csv'
export_branded_food_file_path = 'trimmed/branded_food.csv'
export_food_file_path = 'trimmed/food.csv'
export_food_nutrient_file_path = 'trimmed/food_nutrient.csv'

def export_nutrients(source_nutrient_file_path, export_nutrient_file_path)
  puts "Reading #{source_nutrient_file_path} as CSV..."
  nutrient_table = CSV.parse(File.read(source_nutrient_file_path), headers: true)
  puts "Read in #{source_nutrient_file_path.size} rows.\n"

  puts 'Exporting Nutrients to file...'
  CSV.open(export_nutrient_file_path, "w", :headers => true) do |csv|
    csv << nutrient_table[0].headers
    nutrient_table.each do |row|
      csv << row
    end
  end
  puts 'Done exporting Nutrients.'
end

def export_branded_food(target_ids, source_branded_food_file_path, export_branded_food_file_path)
  id_col = 0

  puts "Reading #{source_branded_food_file_path} as CSV..."
  table = CSV.parse(File.read(source_branded_food_file_path), headers: true)
  puts "Read in #{source_branded_food_file_path.size} rows.\n"

  puts 'Exporting Branded Foods to file...'
  CSV.open(export_branded_food_file_path, "w", :headers => true) do |csv|
    csv << table[0].headers
    table.each do |row|
      csv << row if target_ids.include?(row[id_col])
    end
  end
  puts 'Done exporting Branded Foods.'
end

def export_food(target_ids, source_food_file_path, export_food_file_path)
  id_col = 0

  puts "Reading #{source_food_file_path} as CSV..."
  table = CSV.parse(File.read(source_food_file_path), headers: true)
  puts "Read in #{source_food_file_path.size} rows.\n"

  puts 'Exporting Foods to file...'
  CSV.open(export_food_file_path, "w", :headers => true) do |csv|
    csv << table[0].headers
    table.each do |row|
      csv << row if target_ids.include?(row[id_col])
    end
  end
  puts 'Done exporting Foods.'
end

def export_food_nutrients(target_ids, source_food_nutrient_file_path, export_food_nutrient_file_path)
  id_col = 1

  puts "Reading #{source_food_nutrient_file_path} as CSV..."
  table = CSV.parse(File.read(source_food_nutrient_file_path), headers: true)
  puts "Read in #{source_food_nutrient_file_path.size} rows.\n"

  puts 'Exporting Food Nutrients to file...'
  CSV.open(export_food_nutrient_file_path, "w", :headers => true) do |csv|
    csv << table[0].headers
    table.each do |row|
      csv << row if target_ids.include?(row[id_col])
    end
  end
  puts 'Done exporting Food Nutrients.'
end

export_nutrients(source_nutrient_file_path, export_nutrient_file_path)
export_branded_food(target_ids, source_branded_food_file_path, export_branded_food_file_path)
export_food(target_ids, source_food_file_path, export_food_file_path)
export_food_nutrients(target_ids, source_food_nutrient_file_path, export_food_nutrient_file_path)
