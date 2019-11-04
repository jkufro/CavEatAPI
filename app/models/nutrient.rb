class Nutrient < ApplicationRecord
  has_many :nutrition_facts

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name
  validates_length_of :name, minimum: 1, allow_blank: false
  validates_presence_of :unit
  validates_length_of :unit, minimum: 1, allow_blank: false
  validates :source, source: true, allow_blank: true

  def name=(value)
    super(value&.capitalize_first_letters)
  end

  def alias=(value)
    value.strip! if value.present?
    value = nil unless value.present?
    super(value&.capitalize_first_letters)
  end

  scope :alphabetical, -> { order(:name) }
  scope :sorting_ordered, -> { order(:sorting_order) }

  scope :search, ->(search_term) {
    where("nutrients.name ILIKE ?", "%#{search_term}%")
  }

  def common_name
    self.alias || self.name
  end
end
