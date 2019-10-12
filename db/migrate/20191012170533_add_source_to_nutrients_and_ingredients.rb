class AddSourceToNutrientsAndIngredients < ActiveRecord::Migration[5.2]
  def change
    add_column :nutrients, :source, :string
    add_column :ingredients, :source, :string
  end
end
