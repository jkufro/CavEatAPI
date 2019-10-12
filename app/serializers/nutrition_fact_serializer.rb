class NutritionFactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :source, :amount, :unit
end
