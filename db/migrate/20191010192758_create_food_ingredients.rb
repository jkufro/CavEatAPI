class CreateFoodIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :food_ingredients do |t|
      t.integer :food_id
      t.integer :ingredient_id

      t.timestamps
    end
  end
end
