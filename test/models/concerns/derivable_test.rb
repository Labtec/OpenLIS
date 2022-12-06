# frozen_string_literal: true

require 'test_helper'

class DerivableTest < ActiveSupport::TestCase
  setup do
    @accession = accessions(:egfrcr)
    @patient = @accession.patient
    @creatinine = observations(:crtsa)
    @egfrcr = @accession.results.where(lab_test_id: LabTest.where(code: 'eGFRcr')).take
  end

  test 'verify appropriate calculation of eGFRcr' do
    # AGE            Sex            Serum Creatinine    eGFRcr
    # (years)                       mg/dL               (CKD-EPI 2021)
    #                                                   mL/min/1.73m2
    # ------------------------------------------------------------------
    # <18            Male                               do not calculate
    # <18            Female                             do not calculate
    # 18             Male           0.90                127
    # 18             Male           0.91                125
    # 18             Female         0.70                128
    # 18             Female         0.71                126
    # 90             Male           0.50                97
    # 90             Male           1.50                44
    # 90             Female         0.50                89
    # 90             Female         1.50                33
    # not available                                     do not calculate
    #                not available                      do not calculate
    # Creatinine below or above the measuring interval  do not calculate
    # (analytical measurement range)                    [not tested]

    @creatinine.update(value: 1.00)
    @patient.update(birthdate: 18.years.ago, gender: 'M')
    assert_nil @egfrcr.derived_value

    @creatinine.update(value: 1.00)
    @patient.update(birthdate: 18.years.ago, gender: 'F')
    assert_nil @egfrcr.derived_value

    @patient.update(birthdate: 19.years.ago, gender: 'M')
    @creatinine.update(value: 0.90)
    assert_equal 127, @egfrcr.derived_value

    @patient.update(birthdate: 19.years.ago, gender: 'M')
    @creatinine.update(value: 0.91)
    assert_equal 125, @egfrcr.derived_value

    @patient.update(birthdate: 19.years.ago, gender: 'F')
    @creatinine.update(value: 0.70)
    assert_equal 128, @egfrcr.derived_value

    @patient.update(birthdate: 19.years.ago, gender: 'F')
    @creatinine.update(value: 0.71)
    assert_equal 126, @egfrcr.derived_value

    @patient.update(birthdate: 91.years.ago, gender: 'M')
    @creatinine.update(value: 0.50)
    assert_equal 97, @egfrcr.derived_value

    @patient.update(birthdate: 91.years.ago, gender: 'M')
    @creatinine.update(value: 1.50)
    assert_equal 44, @egfrcr.derived_value

    @patient.update(birthdate: 91.years.ago, gender: 'F')
    @creatinine.update(value: 0.50)
    assert_equal 89, @egfrcr.derived_value

    @patient.update(birthdate: 91.years.ago, gender: 'F')
    @creatinine.update(value: 1.50)
    assert_equal 33, @egfrcr.derived_value

    @patient.update(birthdate: nil)
    assert_nil @egfrcr.derived_value

    @patient.update(birthdate: 91.years.ago, gender: nil)
    assert_nil @egfrcr.derived_value

    @patient.update(gender: 'F')
    @creatinine.update(value: nil)
    assert_nil @egfrcr.derived_value

    # NKF KDOQI and KDIGO guidelines recommend confirming eGFR of
    # 45-59 mL/min/1.73m2 with uACR <30 mg/g based on eGFR calculated
    # using both creatinine and cystatin C.
    @creatinine.update(value: 1.50)
    assert_equal 33, @egfrcr.derived_value
    assert_nil @egfrcr.derived_remarks

    @creatinine.update(value: 1.10)
    assert_equal 48, @egfrcr.derived_value
    assert_not_nil @egfrcr.derived_remarks
  end
end
