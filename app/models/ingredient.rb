class Ingredient < ApplicationRecord
  has_many :food_ingredients
  has_many :foods, through: :food_ingredients

  validates_uniqueness_of :name, scope: :description
end
