class IngredientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :composition, :description, :is_warning
end
