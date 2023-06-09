# frozen_string_literal: true

require 'test_helper'

class AdminClaimsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'admin/claims' }
  end

  test 'routes claims within admin namespace' do
    assert_routing '/admin/claims', @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/admin/claims' },
                   @defaults.merge(action: 'create'))

    assert_routing '/admin/claims/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/admin/claims/1', @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/admin/claims/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/admin/claims/1' },
                   @defaults.merge(action: 'destroy', id: '1'))

    assert_routing({ method: :post, path: '/admin/claims/submit_selected' },
                   @defaults.merge(action: 'submit_selected'))

    assert_routing({ method: :post, path: '/admin/claims/process_selected' },
                   @defaults.merge(action: 'process_selected'))

    assert_routing({ method: :put, path: '/admin/claims/1/submit' },
                   @defaults.merge(action: 'submit', id: '1'))

    assert_routing '/admin/insurance_providers/1/claims',
                   @defaults.merge(action: 'index', insurance_provider_id: '1')

    assert_routing '/admin/accessions/1/claim/new',
                   @defaults.merge(action: 'new', accession_id: '1')
  end
end
