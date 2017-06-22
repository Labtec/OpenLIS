# frozen_string_literal: true

require 'test_helper'

class AdminReferenceRangesRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/reference_ranges' }
  end

  test 'routes reference ranges within admin namespace' do
    assert_routing '/admin/reference_ranges',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/reference_ranges' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/reference_ranges/new',
                   @defaults.merge(action: 'new')

    assert_routing '/admin/reference_ranges/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/reference_ranges/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/reference_ranges/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/reference_ranges/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
