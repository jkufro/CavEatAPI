class Ingredient < ApplicationRecord
  has_many :food_ingredients
  has_many :foods, through: :food_ingredients

  validates_uniqueness_of :name, scope: :composition
  validates_presence_of :name
  validates_length_of :name, minimum: 1, allow_blank: false
  validates :source, source: true, allow_blank: true

  scope :by_name, ->(name) {
    where(name: name)
  }

  scope :by_composition, ->(composition) {
    where(composition: composition)
  }

  scope :search, ->(search_term) {
    where(
      "ingredients.name ILIKE ? OR ingredients.composition ILIKE ?",
      "%#{search_term}%",
      "%#{search_term}%"
    )
  }
end
