require 'test_helper'

class NutritionFactTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to: :food
    should belong_to: :nutrient
  end

  context 'basic validations' do
    should validate_uniqueness_of(:nutrient_id).scoped_to(:food_id)
  end

  context 'amount validation' do
    should validate_numericality_of(:amount).is_greater_than_or_equal_to(0)
    should allow_value(0).for(:amount)
    should allow_value(1.2345).for(:amount)
    should_not allow_value(-1).for(:amount)
    should_not allow_value(-0.0000000001).for(:amount)
  end

  should 'verify that name is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).name, nutrients(:added_sugars).name
    assert_equal nutrition_facts(:food_one_protein).name, nutrients(:protein).name
  end

  should 'verify that description is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).description, nutrients(:added_sugars).description
    assert_equal nutrition_facts(:food_one_protein).description, nutrients(:protein).description
  end

  should 'verify that source is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).source, nutrients(:added_sugars).source
    assert_nil nutrition_facts(:food_one_protein).source
  end

  should 'verify that unit is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).unit, nutrients(:added_sugars).unit
    assert_equal nutrition_facts(:food_one_protein).unit, nutrients(:protein).unit
  end

  should 'verify that is_limiting is accessible' do
    assert_equal nutrition_facts(:food_one_added_sugars).is_limiting, nutrients(:added_sugars).is_limiting
    assert_equal nutrition_facts(:food_one_protein).is_limiting, nutrients(:protein).is_limiting
  end
end
