class NutritionFactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :common_name, :description, :source, :amount, :unit, :is_limiting
end
