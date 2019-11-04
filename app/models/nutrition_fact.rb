class NutritionFact < ApplicationRecord
  belongs_to :nutrient
  belongs_to :food
  delegate :common_name, to: :nutrient, prefix: false, allow_nil: false
  delegate :description, to: :nutrient, prefix: false, allow_nil: false
  delegate :source, to: :nutrient, prefix: false, allow_nil: false
  delegate :unit, to: :nutrient, prefix: false, allow_nil: false
  delegate :is_limiting, to: :nutrient, prefix: false, allow_nil: false

  validates_uniqueness_of :nutrient_id, scope: :food_id
  validates_numericality_of :amount, greater_than_or_equal_to: 0

  default_scope { joins(:nutrient).order(:sorting_order) }
end
