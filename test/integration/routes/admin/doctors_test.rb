# frozen_string_literal: true

require 'test_helper'

class AdminDoctorsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/doctors' }
  end

  test 'routes doctors within admin namespace' do
    assert_routing '/admin/doctors',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/doctors' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/doctors/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/doctors/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing({ method: :patch, path: '/admin/doctors/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/doctors/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
