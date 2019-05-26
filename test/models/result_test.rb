# frozen_string_literal: true

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  setup do
    @result = results(:result)
  end

  test 'text value contains extra spaces' do
    @result.update(lab_test: lab_tests(:text),
                   value: '  Result Value  ')
    assert_equal 'Result Value', @result.value
  end

  test 'no extra spaces between text value words' do
    @result.update(lab_test: lab_tests(:text),
                   value: 'Result  Value')
    assert_equal 'Result Value', @result.value
  end

  test 'derivation of LDL cholesterol' do
    accession = accessions(:lipid)
    accession.result_for('CHOL').update value: 200
    accession.result_for('HDL').update value: 100
    accession.result_for('TRIG').update value: 110
    ldl = accession.result_for('LDL')
    ldl.update unit: units(:unit_a)

    assert_equal 78, ldl.derived_value, 'CHOL - (HDL + TRIG / 5)'

    ldl.update unit: units(:unit_b)

    assert_equal 50, ldl.derived_value, 'CHOL - (HDL + TRIG / 2.2)'

    ldl.update unit: units(:units)

    assert_equal 'calc.', ldl.derived_value
  end

  test 'derivation of LDL/HDL ratio' do
    accession = accessions(:lipid)
    accession.result_for('CHOL').update value: 200
    accession.result_for('HDL').update value: 100
    accession.result_for('TRIG').update value: 110
    ldl = accession.result_for('LDL')
    ldl.update unit: units(:unit_a)
    ldl_hdl = accession.result_for('LDLHDLR')

    assert_equal 0.78, ldl_hdl.derived_value, 'mg/dL'

    ldl.update unit: units(:unit_b)

    assert_equal 0.50, ldl_hdl.derived_value, 'mmol/L'

    ldl.update unit: units(:units)

    assert_equal 'calc.', ldl_hdl.derived_value
  end
end
