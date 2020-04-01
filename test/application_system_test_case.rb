require "test_helper"
require "capybara/poltergeist"
require "custom_system_test_case"

class ApplicationSystemTestCase < CustomSystemTestCase
  driven_by :poltergeist, screen_size: [1400, 1400], options:
    { js_errors: false }
end
