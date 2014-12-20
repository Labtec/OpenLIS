require 'test_helper'

class UserSessionsTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'sessions' }
  end

  test 'routes user sessions' do
    assert_routing '/login',
                   @defaults.merge(action: 'new')

    assert_routing({ method: :post, path: '/login' },
                   @defaults.merge(action: 'create'))

    assert_routing({ method: :delete, path: '/logout' },
                   @defaults.merge(action: 'destroy'))
  end
end
