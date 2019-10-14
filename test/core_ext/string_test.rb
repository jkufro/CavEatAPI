require 'test_helper'

class StringTest < ActiveSupport::TestCase
  context "capitalize_first_letters" do
    should 'show that capitalize_first_letters works' do
      tests = [
        ['', ''],
        [' ', ' '],
        [' _- ', ' _- '],
        ['f', 'F'],
        [' 25g-', ' 25g-'],
        ['This Is A String', 'This Is A String'],
        ['this IS a StRinG', 'This Is A String'],
        ['this is_a-StRinG', 'This Is_A-String'],
        [' this is_a-StRinG', ' This Is_A-String'],
        [' tHIS_iS a sTRING', ' This_Is A String'],
        ['This Is A String (with parens)', 'This Is A String (With Parens)'],
        ['This Is A String(with parens)', 'This Is A String(With Parens)'],
        ['This Is A String{with parens}', 'This Is A String{With Parens}'],
        ['This Is A String[with parens]', 'This Is A String[With Parens]']
      ]
      tests.each do |input, expected|
        assert_equal input.capitalize_first_letters, expected
      end
    end

    should 'show that capitalize_first_letters! works' do
      string = ' tHIS_iS a sTRING'
      string.capitalize_first_letters!
      assert_equal string, ' This_Is A String'
    end
  end
end
