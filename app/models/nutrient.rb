class Nutrient < ApplicationRecord
  has_many :nutrition_facts

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_length_of :name, minimum: 1, allow_blank: false
  validates_presence_of :unit
  validates_length_of :unit, minimum: 1, allow_blank: false
end
