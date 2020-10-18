# frozen_string_literal: true

require 'test_helper'

class ObservationTest < ActiveSupport::TestCase
  setup do
    @observation = observations(:observation)

    def result_for(accession, code)
      lab_test_by_code = LabTest.find_by(code: code)
      accession.results.find_by(lab_test_id: lab_test_by_code)
    end
  end

  test 'text value contains extra spaces' do
    @observation.update(lab_test: lab_tests(:text),
                        value: '  Observation Value  ')
    assert_equal 'Observation Value', @observation.value
  end

  test 'no extra spaces between text value words' do
    @observation.update(lab_test: lab_tests(:text),
                        value: 'Observation  Value')
    assert_equal 'Observation Value', @observation.value
  end

  test 'derivation of LDL cholesterol' do
    accession = accessions(:lipid)
    result_for(accession, 'CHOL').update value: 200
    result_for(accession, 'HDL').update value: 100
    result_for(accession, 'TRIG').update value: 110
    ldl = result_for(accession, 'LDL')
    ldl.update unit: units(:unit_a)

    assert_equal 78, ldl.derived_value, 'CHOL - (HDL + TRIG / 5)'

    ldl.update unit: units(:unit_b)

    assert_equal 50, ldl.derived_value, 'CHOL - (HDL + TRIG / 2.2)'

    ldl.update unit: units(:units)

    assert_nil ldl.derived_value
  end

  test 'derivation of LDL/HDL ratio' do
    accession = accessions(:lipid)
    result_for(accession, 'CHOL').update value: 200
    result_for(accession, 'HDL').update value: 100
    result_for(accession, 'TRIG').update value: 110
    ldl = result_for(accession, 'LDL')
    ldl.update unit: units(:unit_a)
    ldl_hdl = result_for(accession, 'LDLHDLR')

    assert_equal 0.78, ldl_hdl.derived_value, 'mg/dL'

    ldl.update unit: units(:unit_b)

    assert_equal 0.50, ldl_hdl.derived_value, 'mmol/L'

    ldl.update unit: units(:units)

    assert_nil ldl_hdl.derived_value
  end

  test '#value_present? for derived values' do
    accession = accessions(:lipid)
    ldl = accession.results.joins(:lab_test).where('lab_tests.code': 'LDL').take
    assert_not ldl.value_present?

    result_for(accession, 'CHOL').update value: 200
    result_for(accession, 'HDL').update value: 100
    result_for(accession, 'TRIG').update value: 110
    ldl = accession.results.joins(:lab_test).where('lab_tests.code': 'LDL').take
    assert ldl.value_present?
  end
end
