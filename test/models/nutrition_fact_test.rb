require 'test_helper'

class NutritionFactTest < ActiveSupport::TestCase
  should belong_to: :food
  should belong_to: :nutrient

  should validate_numericality_of(:amount).is_greater_than_or_equal_to(0)
  should allow_value(0).for(:amount)
  should allow_value(1.2345).for(:amount)
  should_not allow_value(-1).for(:amount)
  should_not allow_value(-0.0000000001).for(:amount)

  should 'verify that name is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).name, nutrients(:added_sugars).name
    assert_equal nutrition_facts(:food_one_protien).name, nutrients(:protien).name
  end

  should 'verify that description is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).description, nutrients(:added_sugars).description
    assert_equal nutrition_facts(:food_one_protien).description, nutrients(:protien).description
  end

  should 'verify that unit is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).unit, nutrients(:added_sugars).unit
    assert_equal nutrition_facts(:food_one_protien).unit, nutrients(:protien).unit
  end

  should 'verify that is_limiting is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).is_limiting, nutrients(:added_sugars).is_limiting
    assert_equal nutrition_facts(:food_one_protien).is_limiting, nutrients(:protien).is_limiting
  end
end
