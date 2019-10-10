class Food < ApplicationRecord
  has_many :food_ingredients
  has_many :ingredients, through: :food_ingredients
  has_many :nutrition_facts
end
