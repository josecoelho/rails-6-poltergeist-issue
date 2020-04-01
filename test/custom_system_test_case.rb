require "capybara/dsl"
require "capybara/minitest"
require "action_controller"
require "action_dispatch/system_testing/driver"
require "action_dispatch/system_testing/browser"
require "action_dispatch/system_testing/server"
require "action_dispatch/system_testing/test_helpers/screenshot_helper"
require "action_dispatch/system_testing/test_helpers/setup_and_teardown"

# This is basically https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/system_test_case.rb
# witout require "selenium/webdriver"
# Monkey patch to be able to run system tests witout chrome binary avaialble
# See: https://github.com/rails/rails/issues/38856
class CustomSystemTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include ActionDispatch::SystemTesting::TestHelpers::SetupAndTeardown
  include ActionDispatch::SystemTesting::TestHelpers::ScreenshotHelper

  def initialize(*) # :nodoc:
    super
    self.class.driven_by(:selenium) unless self.class.driver?
    self.class.driver.use
  end

  def self.start_application # :nodoc:
    Capybara.app = Rack::Builder.new do
      map "/" do
        run Rails.application
      end
    end

    ActionDispatch::SystemTesting::Server.new.run
  end

  class_attribute :driver, instance_accessor: false

  def self.driven_by(driver, using: :chrome, screen_size: [1400, 1400], options: {}, &capabilities)
    driver_options = { using: using, screen_size: screen_size, options: options }

    self.driver = ActionDispatch::SystemTesting::Driver.new(driver, **driver_options, &capabilities)
  end

  private

  def url_helpers
    @url_helpers ||=
      if ActionDispatch.test_app
        Class.new do
          include ActionDispatch.test_app.routes.url_helpers
          include ActionDispatch.test_app.routes.mounted_helpers

          def url_options
            default_url_options.reverse_merge(host: Capybara.app_host || Capybara.current_session.server_url)
          end
        end.new
      end
  end

  def method_missing(name, *args, &block)
    if url_helpers.respond_to?(name)
      url_helpers.public_send(name, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(name, _include_private = false)
    url_helpers.respond_to?(name)
  end
end

ActiveSupport.run_load_hooks :action_dispatch_system_test_case, CustomSystemTestCase
CustomSystemTestCase.start_application