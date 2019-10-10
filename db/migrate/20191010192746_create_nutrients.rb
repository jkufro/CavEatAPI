class CreateNutrients < ActiveRecord::Migration[5.2]
  def change
    create_table :nutrients do |t|
      t.string :name
      t.text :description
      t.string :unit
      t.boolean :is_limiting

      t.timestamps
    end
  end
end
