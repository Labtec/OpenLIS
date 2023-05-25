# frozen_string_literal: true

require 'test_helper'

class AdminQualifiedValuesRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/qualified_values' }
  end

  test 'routes qualified intervals within admin namespace' do
    assert_routing '/admin/qualified_values',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/qualified_values' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/qualified_values/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/qualified_values/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/qualified_values/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/qualified_values/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/qualified_values/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
