class IngredientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :composition, :description, :source, :is_warning
end
