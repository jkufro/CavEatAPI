require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:food_ingredients)
    should have_many(:foods).through(:food_ingredients)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name).scoped_to(:description)
  end
end
