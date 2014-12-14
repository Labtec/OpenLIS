require 'test_helper'

class UserSessionsTest < ActionDispatch::IntegrationTest
  test 'routes user sessions' do
    assert_routing('/login',
                   { controller: 'sessions', action: 'new' })

    assert_routing({ method: :post, path: '/login' },
                   { controller: 'sessions', action: 'create' })

    assert_routing({ method: :delete, path: '/logout' },
                   { controller: 'sessions', action: 'destroy' })
  end
end
