class Food < ApplicationRecord
  has_many :food_ingredients
  has_many :ingredients, through: :food_ingredients
  has_many :nutrition_facts

  validates_numericality_of :upc, only_integer: true, greater_than_or_equal_to: 0
  validates_uniqueness_of :upc
end
