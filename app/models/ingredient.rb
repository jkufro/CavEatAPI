class Ingredient < ApplicationRecord
  has_many :food_ingredients
  has_many :foods, through: :food_ingredients

  validates_uniqueness_of :name, scope: :composition, :case_sensitive => false
  validates_presence_of :name
  validates_length_of :name, minimum: 1, allow_blank: false
  validates :source, source: true, allow_blank: true

  scope :by_name, ->(name) {
    where(name: name)
  }

  scope :by_composition, ->(composition) {
    where(composition: composition)
  }

  # in the format [['name', 'composition'], ...]
  scope :by_name_composition_pairs, ->(pairs) {
    return if pairs.empty?
    query = '(LOWER(name) = ? AND LOWER(composition) = ?)'

    pairs.each_with_index do |pair, indx|
      next if indx == 0
      query += ' OR (LOWER(name) = ? AND LOWER(composition) = ?)'
    end

    where(query, *pairs.flatten.map(&:downcase))
  }

  scope :search, ->(search_term) {
    where(
      "ingredients.name ILIKE ? OR ingredients.composition ILIKE ?",
      "%#{search_term}%",
      "%#{search_term}%"
    )
  }

  def hash
    return calculated_hash if calculated_hash
    calculated_hash = [name.downcase, composition&.downcase].hash
  end

  def ==(o)
    o.class == self.class && o.hash == hash
  end

  def eql?(other)
    self == other
  end

  private
    attr_accessor :calculated_hash
end
