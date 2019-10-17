class ChangeFoodUpcFromIntToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :foods, :upc, :bigint
  end
end
