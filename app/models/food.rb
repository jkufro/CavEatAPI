class Food < ApplicationRecord
  has_many :food_ingredients, dependent: :destroy
  has_many :ingredients, -> { order(is_warning: :desc, id: :asc) }, through: :food_ingredients
  has_many :nutrition_facts, dependent: :destroy

  validates_numericality_of :upc, only_integer: true, greater_than_or_equal_to: 0
  validates_uniqueness_of :upc
  validates_presence_of :upc

  def name=(value)
    super(value&.capitalize_first_letters)
  end

  scope :alphabetical, -> { order(:name) }

  scope :search, ->(search_term) {
    where(
      "foods.upc = ? OR foods.name ILIKE ? ",
      search_term.to_i,
      "%#{search_term}%"
    )
  }
end
