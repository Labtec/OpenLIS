# frozen_string_literal: true

require 'test_helper'

class WebauthnCredentialsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'settings/webauthn_credentials' }
  end

  test 'routes webauthn_credentials within settings namespace' do
    assert_routing '/settings/security_keys/new',
                   @defaults.merge(action: 'new')

    assert_routing({ method: :post, path: '/settings/security_keys' },
                   @defaults.merge(action: 'create'))

    assert_routing({ method: :delete, path: 'settings/security_keys/1' },
                   @defaults.merge(action: 'destroy', id: '1'))

    assert_routing '/settings/security_keys/options',
                   @defaults.merge(action: 'options')
  end
end
