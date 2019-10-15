require 'test_helper'

class NutrientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:nutrition_facts)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name).case_insensitive
    should validate_presence_of(:name)
    should validate_length_of(:name).is_at_least(1)

    should validate_presence_of(:unit)
    should validate_length_of(:unit).is_at_least(1)

    should allow_value(nil).for(:source)
    should allow_value('').for(:source)
    should allow_value('http://google.com').for(:source)
    should allow_value('https://google.com').for(:source)
    should allow_value('https://cmu.edu').for(:source)
    should allow_value('http://cmu.edu?foo=bar&fizz=buzz').for(:source)
    should_not allow_value('foo').for(:source)
    should_not allow_value(22).for(:source)
    should_not allow_value(22.123133).for(:source)
    should_not allow_value(true).for(:source)
    should_not allow_value(false).for(:source)
    should_not allow_value(Ingredient.new).for(:source)
    should_not allow_value('google.com').for(:source)
  end

  context 'alias' do
    should 'should show that common_name works' do
      assert_nil nutrients(:added_sugars).alias
      assert_equal nutrients(:added_sugars).name, nutrients(:added_sugars).common_name

      nutrients(:added_sugars).alias = ''
      assert_nil nutrients(:added_sugars).alias
      assert_equal nutrients(:added_sugars).name, nutrients(:added_sugars).common_name

      nutrients(:added_sugars).alias = "  \n \t"
      assert_nil nutrients(:added_sugars).alias
      assert_equal nutrients(:added_sugars).name, nutrients(:added_sugars).common_name

      nutrients(:added_sugars).alias = 'Wow Sugar'
      assert_equal nutrients(:added_sugars).alias, nutrients(:added_sugars).common_name
    end
  end

  context 'scopes' do
    should 'show that the search scope works' do
      result = Nutrient.search(nil)
      assert_equal 2, result.size

      result = Nutrient.search('')
      assert_equal 2, result.size

      result = Nutrient.search('e')
      assert_equal 2, result.size

      result = Nutrient.search('sugar')
      assert_equal 1, result.size
      assert_equal nutrients(:added_sugars).name, result.first.name

      result = Nutrient.search('pro')
      assert_equal 1, result.size
      assert_equal nutrients(:protein).name, result.first.name
    end

    should 'show that the alphabetical scope works' do
      assert_equal [nutrients(:added_sugars), nutrients(:protein)], Nutrient.alphabetical.to_a
    end
  end
end
