# frozen_string_literal: true

require 'test_helper'

class AccessionDerivableTest < ActiveSupport::TestCase
  setup do
    @accession = accessions(:lipid)

    def result_for(accession, code)
      accession.results.joins(:lab_test).where('lab_tests.code': code).take
    end
  end

  test 'derivation of LDL cholesterol' do
    result_for(@accession, 'CHOL').update value: 200
    result_for(@accession, 'HDL').update value: 100
    result_for(@accession, 'TRIG').update value: 110
    ldl = result_for(@accession, 'LDL')
    ldl.update unit: units(:unit_a)

    assert_equal 78, ldl.derived_value, 'CHOL - (HDL + TRIG / 5)'

    ldl.update unit: units(:unit_b)

    assert_equal 50, ldl.derived_value, 'CHOL - (HDL + TRIG / 2.2)'

    ldl.update unit: units(:units)

    assert_nil ldl.derived_value
  end

  test 'derivation of LDL/HDL ratio' do
    result_for(@accession, 'CHOL').update value: 200
    result_for(@accession, 'HDL').update value: 100
    result_for(@accession, 'TRIG').update value: 110
    ldl = result_for(@accession, 'LDL')
    ldl.update unit: units(:unit_a)
    ldl_hdl = result_for(@accession, 'LDLHDLR')

    assert_equal 0.78, ldl_hdl.derived_value, 'mg/dL'

    ldl.update unit: units(:unit_b)

    assert_equal 0.50, ldl_hdl.derived_value, 'mmol/L'

    ldl.update unit: units(:units)

    assert_nil ldl_hdl.derived_value
  end

  test '#value_present? for derived values' do
    ldl = @accession.results.joins(:lab_test).where('lab_tests.code': 'LDL').take
    assert_not ldl.value_present?

    result_for(@accession, 'CHOL').update value: 200
    result_for(@accession, 'HDL').update value: 100
    result_for(@accession, 'TRIG').update value: 110
    ldl = @accession.results.joins(:lab_test).where('lab_tests.code': 'LDL').take
    assert ldl.value_present?
  end
end
