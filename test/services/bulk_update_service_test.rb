require 'test_helper'

class BulkUpdateServiceTest < ActiveSupport::TestCase
  should 'successfully update all' do
    num_failed = BulkUpdateService.bulk_update(ingredients, { description: 'foobar', is_warning: true })
    assert_equal 0, num_failed
    ingredients.each do |ingredient|
      ingredient.reload
      assert_equal 'foobar', ingredient.description
      assert_equal true, ingredient.is_warning
    end
  end

  should 'fail to update' do
    num_failed = BulkUpdateService.bulk_update(ingredients, { name: nil })
    assert_equal ingredients.size, num_failed
    ingredients.each do |ingredient|
      ingredient.reload
      assert_not_nil ingredient.name
    end
  end
end
