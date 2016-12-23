require 'test_helper'

class AccessionsRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'accessions' }
  end

  test 'routes accessions' do
    assert_routing '/accessions',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/patients/1/accessions' },
                   @defaults.merge(action: 'create', patient_id: '1'))

    assert_routing '/patients/1/accessions/new',
                   @defaults.merge(action: 'new', patient_id: '1')

    assert_routing '/accessions/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/accessions/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/accessions/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/accessions/1' },
                   @defaults.merge(action: 'destroy', id: '1'))

    assert_routing({ method: :patch, path: '/accessions/1/report' },
                   @defaults.merge(action: 'report', id: '1'))

    assert_routing '/accessions/1/edit_results',
                   @defaults.merge(action: 'edit_results', id: '1')
  end
end
