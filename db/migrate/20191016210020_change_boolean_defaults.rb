class ChangeBooleanDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column_default :ingredients, :is_warning, false
    change_column_default :nutrients, :is_limiting, false
  end
end
