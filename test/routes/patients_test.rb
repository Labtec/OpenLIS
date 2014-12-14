require 'test_helper'

class PatientsTest < ActionDispatch::IntegrationTest
  test 'routes patients' do
    assert_routing('/',
                   { controller: 'patients', action: 'index' })

    assert_routing({ method: :post, path: '/patients' },
                   { controller: 'patients', action: 'create' })

    assert_routing('/patients/new',
                   { controller: 'patients', action: 'new' })

    assert_routing('/patients/1/edit',
                   { controller: 'patients', action: 'edit', id: '1' })

    assert_routing('/patients/1',
                   { controller: 'patients', action: 'show', id: '1' })

    assert_routing({ method: :patch, path: '/patients/1' },
                   { controller: 'patients', action: 'update', id: '1' })

    assert_routing({ method: :delete, path: '/patients/1' },
                   { controller: 'patients', action: 'destroy', id: '1' })
  end
end
