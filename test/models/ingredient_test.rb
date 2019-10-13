require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:food_ingredients)
    should have_many(:foods).through(:food_ingredients)
  end

  context 'basic validations' do
    should validate_uniqueness_of(:name).scoped_to(:composition)
    should validate_presence_of(:name)
    should validate_length_of(:name).is_at_least(1)
  end

  context 'hashing and equality' do
    should 'satisfy all requirements' do
      i1 = Ingredient.new(name: 'salt', composition: '(salt duh)')
      i2 = Ingredient.new(name: 'salt', composition: '(salt duh)')
      i3 = Ingredient.new(name: 'salt', composition: '!!!(salt duh)')
      i4 = Ingredient.new(name: 'salt!!!', composition: '(salt duh)')
      i5 = Ingredient.new(name: 'corn', composition: '')
      assert i1 == i1
      assert i1 == i2
      assert i1 != i3
      assert i1 != i4
      assert i2 == i2
      assert i2 != i3
      assert i2 != i4
      assert i3 == i3
      assert i3 != i4
      assert i4 == i4
      assert i4 != i5
      assert i5 == i5

      assert i1.eql? i1
      assert i1.eql? i2
      assert_not i1.eql? i3
      assert_not i1.eql? i4
      assert i2.eql? i2
      assert_not i2.eql? i3
      assert_not i2.eql? i4
      assert i3.eql? i3
      assert_not i3.eql? i4
      assert i4.eql? i4
      assert_not i4.eql? i5
      assert i5.eql? i5

      ingredients_hash = { i1 => i1, i3 => i3 }
      ingredients_hash.default = nil
      assert_equal i1, ingredients_hash[i1]
      assert_equal i1, ingredients_hash[i2]
      assert_equal i3, ingredients_hash[i3]
      assert_nil ingredients_hash[i4]
      assert_nil ingredients_hash[i5]
    end
  end

  context 'scopes' do
    should 'show that by_name scope works' do
      result = Ingredient.by_name('no food with this name')
      assert_equal 0, result.size

      result = Ingredient.by_name('ingredient_on')
      assert_equal 0, result.size

      result = Ingredient.by_name(ingredients(:ingredient_one).name)
      assert_equal 1, result.size
      assert_equal ingredients(:ingredient_one).name, result.first.name

      result = Ingredient.by_name(ingredients(:ingredient_two).name)
      assert_equal 1, result.size
      assert_equal ingredients(:ingredient_two).name, result.first.name
    end

    should 'show that composition scope works' do
      result = Ingredient.by_composition('no food with this composition')
      assert_equal 0, result.size

      result = Ingredient.by_composition('Composition for ')
      assert_equal 0, result.size

      result = Ingredient.by_composition(ingredients(:ingredient_one).composition)
      assert_equal 1, result.size
      assert_equal ingredients(:ingredient_one).name, result.first.name

      result = Ingredient.by_composition(ingredients(:ingredient_two).composition)
      assert_equal 1, result.size
      assert_equal ingredients(:ingredient_two).name, result.first.name
    end

    should 'show that search by name works' do
      search = Ingredient.all.search(nil)
      assert_equal 2, search.size

      search = Ingredient.all.search('')
      assert_equal 2, search.size

      search = Ingredient.all.search('ingredient')
      assert_equal 2, search.size

      search = Ingredient.all.search(ingredients(:ingredient_one).name)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_one).name, search.first.name

      search = Ingredient.all.search(ingredients(:ingredient_two).name)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_two).name, search.first.name
    end

    should 'show that search by composition works' do
      search = Ingredient.all.search('')
      assert_equal 2, search.size

      search = Ingredient.all.search('Composition for ')
      assert_equal 2, search.size

      search = Ingredient.all.search(ingredients(:ingredient_one).composition)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_one).composition, search.first.composition

      search = Ingredient.all.search(ingredients(:ingredient_two).composition)
      assert_equal 1, search.size
      assert_equal ingredients(:ingredient_two).composition, search.first.composition
    end
  end
end
