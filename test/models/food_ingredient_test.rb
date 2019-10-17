require 'test_helper'

class FoodIngredientTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:food)
    should belong_to(:ingredient)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:ingredient_id).scoped_to(:food_id)
  end
end
