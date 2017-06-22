# frozen_string_literal: true

require 'test_helper'

class AdminDepartmentsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/departments' }
  end

  test 'routes departments within admin namespace' do
    assert_routing '/admin/departments',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/departments' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/departments/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/departments/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/departments/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/departments/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/departments/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
