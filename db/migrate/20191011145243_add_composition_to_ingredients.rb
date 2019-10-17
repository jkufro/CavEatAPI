class AddCompositionToIngredients < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :composition, :string
  end
end
