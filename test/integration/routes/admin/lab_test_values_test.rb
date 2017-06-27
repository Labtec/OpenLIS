# frozen_string_literal: true

require 'test_helper'

class AdminLabTestValuesRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/lab_test_values' }
  end

  test 'routes lab test values within admin namespace' do
    assert_routing '/admin/lab_test_values',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/lab_test_values' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/lab_test_values/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/lab_test_values/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/lab_test_values/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/lab_test_values/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/lab_test_values/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
