require 'test_helper'

class NutrientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name)
  end
end
