require 'test_helper'

class AccessionsRoutesTest < ActionDispatch::IntegrationTest
  test 'routes accessions' do
    assert_routing('/accessions',
                   { controller: 'accessions', action: 'index' })

    assert_routing({ method: :post, path: '/patients/1/accessions' },
                   { controller: 'accessions', action: 'create', patient_id: '1' })

    assert_routing('/patients/1/accessions/new',
                   { controller: 'accessions', action: 'new', patient_id: '1' })

    assert_routing('/accessions/1/edit',
                   { controller: 'accessions', action: 'edit', id: '1' })

    assert_routing('/accessions/1',
                   { controller: 'accessions', action: 'show', id: '1' })

    assert_routing({ method: :patch, path: '/accessions/1' },
                   { controller: 'accessions', action: 'update', id: '1' })

    assert_routing({ method: :delete, path: '/accessions/1' },
                   { controller: 'accessions', action: 'destroy', id: '1' })

    assert_routing({ method: :put, path: '/accessions/1/report' },
                   { controller: 'accessions', action: 'report', id: '1' })

    assert_routing('/accessions/1/edit_results',
                   { controller: 'accessions', action: 'edit_results', id: '1' })
  end
end
