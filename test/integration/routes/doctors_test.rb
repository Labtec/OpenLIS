require 'test_helper'

class DoctorsRoutesTest < ActionDispatch::IntegrationTest
  test 'routes doctors' do
    assert_routing '/doctors', controller: 'doctors', action: 'index'
  end
end
