require 'test_helper'

class NutrientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
  end
end
