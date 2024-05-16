# frozen_string_literal: true

require 'test_helper'

class CedulaTest < ActiveSupport::TestCase
  test 'digito verificador' do
    assert_equal '47', Cedula::dv('8-NT-1-1')
    assert_equal '91', Cedula::dv('8-274-125')
    assert_equal '61', Cedula::dv('8-274-1253')
    assert_equal '63', Cedula::dv('E-1-11')
    assert_equal '60', Cedula::dv('PE-1-19')
    assert_equal '05', Cedula::dv('8-PI-1-80')
    assert_equal '60', Cedula::dv('8-AV-1-80')
  end
end
