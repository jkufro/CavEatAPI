require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
    should have_many(:food_ingredients)
    should have_many(:ingredients).through(:food_ingredients)
  end
end
