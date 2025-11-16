ENV["RAILS_ENV"] ||= "test"

# Suppress Ruby 3.4 frozen string literal warnings from dependencies
Warning[:deprecated] = false if Warning.respond_to?(:[]=)

# SimpleCov must be started before loading application code
if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.start "rails" do
    add_filter "/test/"
    add_filter "/config/"
    add_filter "/vendor/"

    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    add_group "Services", "app/services"
    add_group "Mailers", "app/mailers"
    add_group "Helpers", "app/helpers"
    add_group "Jobs", "app/jobs"

    minimum_coverage 30
    maximum_coverage_drop 20
  end
end

require_relative "../config/environment"
require "rails/test_help"

# CRITICAL: Eager load all classes BEFORE mocha to prevent stub interference
# When mocha loads before classes, it can create placeholder methods that block real method definitions
Rails.application.eager_load!

# Load mocha AFTER all app classes are loaded
require "mocha/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # Disable parallelization to avoid class loading issues with Factory.with_connection
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Sign in a user for controller tests
    def sign_in_as(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
      assert_response :redirect
    end
  end
end
