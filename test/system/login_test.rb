# frozen_string_literal: true

require 'application_system_test_case'

module System
  class LoginTest < ApplicationSystemTestCase
    def setup
      Capybara.reset_sessions!
    end

    def teardown
      Warden.test_reset!
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

    test 'logging in as a user with webauthn' do
      visit user_session_path
      fill_in 'Username', with: 'webauthn'
      fill_in 'Password', with: 'password'
      click_on 'Log In'
      assert_not page.has_content?('WebAuthn is not enabled')
      assert_not page.has_content?("This browser doesn't support security keys")
      assert page.has_content?('When you are ready, authenticate using the button below.')
    end
  end
end
