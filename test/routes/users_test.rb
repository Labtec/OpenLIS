require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'routes users' do
    assert_routing('/profile',
                   { controller: 'users', action: 'edit' })

    assert_routing({ method: :patch, path: '/users/1' },
                   { controller: 'users', action: 'update', id: '1' })
  end
end
