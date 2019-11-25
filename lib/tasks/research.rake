namespace :db do
  desc "update ingredient description, source, warning from csv"
  task :research => :environment do
    require 'csv'

    file_path = 'lib/data/ingredient_research.csv'

    def update_ingredients(file_path)
      search_term_col, ingredient_name_col, description_col, warning_col, source_col = 0, 1, 2, 3, 4

      puts "Updating Ingredients in database from #{file_path}...\n\n"
      File.open(file_path, 'r') do |file|
        csv = CSV.new(file, headers: true)

        while row = csv.shift
          search_term = row[search_term_col]&.capitalize_first_letters
          ingredient_name = row[ingredient_name_col]&.capitalize_first_letters
          update_params = { description: row[description_col], is_warning: row[warning_col], source: row[source_col] }

          unless search_term.blank? # group update
            print "Bulk updating ingredients that match search '#{search_term}'... "
            ingredients = Ingredient.all.search(search_term)
            failed_updates = BulkUpdateService.bulk_update(ingredients, update_params)
            unless failed_updates == 0
              print "#{failed_updates} ingredients failed to update! "
            end
          else # single ingredient update
            print "Updating single ingredient with name #{ingredient_name}... "
            ingredient = Ingredient.all.find_by_name(ingredient_name)
            if ingredient
              unless ingredient.update_attributes(update_params)
                print 'Failed to update ingredient! '
              end
            else
              print 'Did not find Ingredient! '
            end
          end
          puts 'Done'
        end
      end
      puts "Done updating Ingredients.\n\n"
    end

    update_ingredients(file_path)
  end
end
