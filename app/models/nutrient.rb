class Nutrient < ApplicationRecord
  has_many :nutrition_facts

  validates_uniqueness_of :name
end
