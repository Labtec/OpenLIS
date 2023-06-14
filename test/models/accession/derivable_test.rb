# frozen_string_literal: true

require 'test_helper'

class AccessionDerivableTest < ActiveSupport::TestCase
  setup do
    @accession = accessions(:lipid)

    def result_for(accession, code)
      accession.results.joins(:lab_test).where('lab_tests.code': code).take
    end
  end

  test 'derivation of LDL cholesterol (Friedewald)' do
    result_for(@accession, 'CHOL').update value: 200
    result_for(@accession, 'HDL').update value: 100
    result_for(@accession, 'TRIG').update value: 110
    ldl = result_for(@accession, 'LDL')
    ldl.update unit: units('mg/dl')

    assert_equal 78, @accession.derived_value_for('LDL'), 'CHOL - (HDL + TRIG / 5)'

    ldl.update unit: units('mmol/l')

    assert_equal 50, @accession.derived_value_for('LDL'), 'CHOL - (HDL + TRIG / 2.2)'

    ldl.update unit: units(:units)

    assert_nil @accession.derived_value_for('LDL')
  end

  test 'derivation of LDL cholesterol (Sampson)' do
    @accession = accessions(:lpsc1)

    result_for(@accession, 'CHOL').update value: 125
    result_for(@accession, 'HDL').update value: 85
    result_for(@accession, 'TRIG').update value: 75
    ldl = result_for(@accession, 'CLDL1')
    ldl.update unit: units('mg/dl')

    assert_equal 25, @accession.derived_value_for('CLDL1').round, 'mg/dL'

    ldl.update unit: units('mmol/l')

    result_for(@accession, 'CHOL').update value: 3.2
    result_for(@accession, 'HDL').update value: 2.2
    result_for(@accession, 'TRIG').update value: 0.85

    assert_equal 0.6, @accession.derived_value_for('CLDL1').round(1), 'mmol/l'

    ldl.update unit: units(:units)

    assert_nil @accession.derived_value_for('CLDL1')
  end

  test 'derivation of LDL/HDL ratio' do
    result_for(@accession, 'CHOL').update value: 200
    result_for(@accession, 'HDL').update value: 100
    result_for(@accession, 'TRIG').update value: 110
    ldl = result_for(@accession, 'LDL')
    ldl.update unit: units('mg/dl')

    assert_equal 0.78, @accession.derived_value_for('LDLHDLR'), 'mg/dL'

    ldl.update unit: units('mmol/l')

    assert_equal 0.50, @accession.derived_value_for('LDLHDLR'), 'mmol/L'

    ldl.update unit: units(:units)

    assert_nil @accession.derived_value_for('LDLHDLR')
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
