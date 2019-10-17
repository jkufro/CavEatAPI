class AddFoodIndexToTables < ActiveRecord::Migration[5.2]
  def change
    add_index :nutrition_facts, :food_id
    add_index :food_ingredients, :food_id
  end
end
