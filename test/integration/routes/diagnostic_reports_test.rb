# frozen_string_literal: true

require 'test_helper'

class DiagnosticReportsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'diagnostic_reports' }
  end

  test 'routes diagnostic_reports' do
    assert_routing '/diagnostic_reports',
                   @defaults.merge(action: 'index')

    assert_routing '/diagnostic_reports/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing '/diagnostic_reports/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing({ method: :patch, path: '/diagnostic_reports/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :patch, path: '/diagnostic_reports/1/certify' },
                   @defaults.merge(action: 'certify', id: '1'))

    assert_routing({ method: :put, path: '/diagnostic_reports/1/email' },
                   @defaults.merge(action: 'email', id: '1'))
  end
end
