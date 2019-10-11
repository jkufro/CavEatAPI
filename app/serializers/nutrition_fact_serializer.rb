class NutritionFactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :amount, :unit
end
