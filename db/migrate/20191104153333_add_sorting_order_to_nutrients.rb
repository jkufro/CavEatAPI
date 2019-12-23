class AddSortingOrderToNutrients < ActiveRecord::Migration[5.2]
  def change
    add_column :nutrients, :sorting_order, :integer
  end
end
