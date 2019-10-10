class FoodIngredient < ApplicationRecord
  belongs_to :food
  belongs_to :ingredient

  validates_uniqueness_of :ingredient_id, scope: :food_id
end
