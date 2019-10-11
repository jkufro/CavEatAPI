class Ingredient < ApplicationRecord
  has_many :food_ingredients
  has_many :foods, through: :food_ingredients

  scope :by_name, ->(name) {
    where(name: name)
  }
  scope :by_description, ->(description) {
    where(description: description)
  }
end
