require 'test_helper'

class NutrientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name)
    should validate_presence_of(:name)
    should validate_length_of(:name).is_at_least(1)

    should validate_presence_of(:unit)
    should validate_length_of(:unit).is_at_least(1)
  end
end
