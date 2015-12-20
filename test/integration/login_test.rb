require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.reset_sessions!
  end

  test 'logging in as a user' do
    visit user_session_path
    fill_in 'Username', with: 'user'
    fill_in 'Password', with: 'password'
    click_on 'Log In'
    assert_not page.has_content?('ERROR')
    assert_not page.has_content?('Admin')
  end

  test 'logging in as an admin' do
    visit user_session_path
    fill_in 'Username', with: 'admin'
    fill_in 'Password', with: 'password'
    click_on 'Log In'
    assert_not page.has_content?('ERROR')
    assert page.has_content?('Admin')
  end
end
