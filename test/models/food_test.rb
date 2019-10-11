require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
    should have_many(:food_ingredients)
    should have_many(:ingredients).through(:food_ingredients)
  end

  context 'upc validation' do
    should validate_uniqueness_of(:upc)

    should validate_numericality_of(:upc).only_integer.is_greater_than_or_equal_to(0)
    should allow_value(0).for(:upc)
    should allow_value(123456789012).for(:upc)
    should_not allow_value(1.2345).for(:upc)
    should_not allow_value(-1).for(:upc)
    should_not allow_value(-0.0000000001).for(:upc)
  end

  context 'scopes' do
    should 'show that search by upc works' do
      search = Food.all.search(foods(:food_one).upc.to_s)
      assert_equal 1, search.size
      assert_equal foods(:food_one).upc, search.first.upc

      search = Food.all.search(foods(:food_two).upc.to_s)
      assert_equal 1, search.size
      assert_equal foods(:food_two).upc, search.first.upc
    end

    should 'show that search by name works' do
      search = Food.all.search('')
      assert_equal 2, search.size

      search = Food.all.search('food')
      assert_equal 2, search.size

      search = Food.all.search(foods(:food_one).name)
      assert_equal 1, search.size
      assert_equal foods(:food_one).upc, search.first.upc

      search = Food.all.search(foods(:food_two).name)
      assert_equal 1, search.size
      assert_equal foods(:food_two).upc, search.first.upc
    end
  end
end
