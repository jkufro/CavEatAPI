class CreateNutritionFacts < ActiveRecord::Migration[5.2]
  def change
    create_table :nutrition_facts do |t|
      t.integer :food_id
      t.integer :nutrient_id
      t.float :amount

      t.timestamps
    end
  end
end
