class Ingredient < ApplicationRecord
  has_many :food_ingredients
  has_many :foods, through: :food_ingredients

  validates_uniqueness_of :name, scope: :description

  scope :search, ->(search_term) {
    where(
      "ingredients.name ILIKE ? OR ingredients.description ILIKE ?",
      "%#{search_term}%",
      "%#{search_term}%"
    )
  }
end
