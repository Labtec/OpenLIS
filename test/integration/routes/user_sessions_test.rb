# frozen_string_literal: true

require 'test_helper'

class UserSessionsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { format: false, controller: 'auth/sessions' }
  end

  test 'routes user sessions' do
    assert_routing '/login',
                   @defaults.merge(action: 'new')

    assert_routing({ method: :post, path: '/login' },
                   @defaults.merge(action: 'create'))

    assert_routing({ method: :delete, path: '/logout' },
                   @defaults.merge(action: 'destroy'))

    assert_routing '/auth/sessions/security_key_options',
                   { controller: 'auth/sessions', action: 'webauthn_options' }
  end
end
