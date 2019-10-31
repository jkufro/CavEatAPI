class CreateStringRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :string_requests do |t|
      t.string :upc
      t.string :nutrition_facts_string
      t.string :ingredients_string

      t.timestamps
    end
  end
end
