# frozen_string_literal: true

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
    visit root_path
    assert_not page.has_content?('Admin')
    assert page.has_content?('user')
  end

  test 'logging in as an admin' do
    visit user_session_path
    fill_in 'Username', with: 'admin'
    fill_in 'Password', with: 'password'
    click_on 'Log In'
    assert_not page.has_content?('ERROR')
    visit root_path
    assert page.has_content?('Admin')
    assert page.has_content?('admin')
  end

  test 'logging in as a user with webauthn no javascript support' do
    visit user_session_path
    fill_in 'Username', with: 'webauthn'
    fill_in 'Password', with: 'password'
    click_on 'Log In'
    assert_not page.has_content?('WebAuthn is not enabled')
    assert page.has_content?("This browser doesn't support security keys")
  end
end
