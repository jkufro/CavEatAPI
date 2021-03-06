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

  should 'verify that link_if_present works as expected' do
    assert_equal 'N/A', link_if_present(nil)
    assert_equal 'N/A', link_if_present('')
    assert_equal 'FOOBAR', link_if_present('', 'Source', 'FOOBAR')
    assert_equal '<a href="http://google.com">Source</a>', link_if_present('http://google.com', 'Source', 'FOOBAR')
  end
end
