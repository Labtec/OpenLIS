# frozen_string_literal: true

require 'test_helper'

class AdminUnitsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/units' }
  end

  test 'routes units within admin namespace' do
    assert_routing '/admin/units',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/units' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/units/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/units/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/units/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/units/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/units/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
