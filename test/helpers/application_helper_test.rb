require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  should 'verify that flash_class works as expected' do
    assert_equal flash_class('notice'), "alert alert-primary"
    assert_equal flash_class('success'), "alert alert-success"
    assert_equal flash_class(:error), "alert alert-danger"
    assert_equal flash_class(:alert), "alert alert-warning"
    assert_equal flash_class('give me default'), "alert alert-info"
  end
end
