class FoodSerializer
  include FastJsonapi::ObjectSerializer
  set_type :food  # optional
  attributes :upc, :name
  has_many :ingredients
  has_many :nutrition_facts
end
