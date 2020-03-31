require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'GET' do
    visit root_url
    assert_text 'Welcome to this test page'
  end
end