require 'test_helper'

class FoodIngredientTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:food)
    should belong_to(:ingredient)
  end
end
