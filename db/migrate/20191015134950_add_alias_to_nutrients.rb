class AddAliasToNutrients < ActiveRecord::Migration[5.2]
  def change
    add_column :nutrients, :alias, :string
  end
end
