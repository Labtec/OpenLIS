require 'test_helper'

class PatientsTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'patients' }
  end

  test 'routes patients' do
    assert_routing '/',
                   @defaults.merge(action: 'index')

    assert_routing({ method: :post, path: '/patients' },
                   @defaults.merge(action: 'create'))

    assert_routing '/patients/new',
                   @defaults.merge(action: 'new')

    assert_routing '/patients/1/edit',
                   @defaults.merge(action: 'edit', id: '1')

    assert_routing '/patients/1',
                   @defaults.merge(action: 'show', id: '1')

    assert_routing({ method: :patch, path: '/patients/1' },
                   @defaults.merge(action: 'update', id: '1'))

    assert_routing({ method: :delete, path: '/patients/1' },
                   @defaults.merge(action: 'destroy', id: '1'))
  end
end
