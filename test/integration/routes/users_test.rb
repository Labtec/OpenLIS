# frozen_string_literal: true

require 'test_helper'

class UsersRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'users' }
  end

  test 'routes users' do
    assert_routing '/profile', @defaults.merge(action: 'edit')

    assert_routing({ method: :patch, path: '/users/1' },
                   @defaults.merge(action: 'update', id: '1'))
  end
end
