class ChangeFoodUpcFromStringToInt < ActiveRecord::Migration[5.2]
  def change
    # https://makandracards.com/makandra/18691-postgresql-vs-rails-migration-how-to-change-columns-from-string-to-integer
    change_column :foods, :upc, 'integer USING CAST(upc AS integer)'
  end
end
