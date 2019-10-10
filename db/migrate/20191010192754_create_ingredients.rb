class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.text :description
      t.boolean :is_warning

      t.timestamps
    end
  end
end
