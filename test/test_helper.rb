require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "lib/data/data_trimmer.rb"
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"

# load extension libraries https://github.com/colszowka/simplecov/issues/221
Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| puts load l }

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    # with.test_framework :rspec
    with.test_framework :minitest
    # with.test_framework :minitest_4
    # with.test_framework :test_unit

    # Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def login_user_one
    get login_path
    post sessions_path, params: { username: users(:user_one).username, password: "secret" }
  end

  def logout
    get logout_path
  end
end
