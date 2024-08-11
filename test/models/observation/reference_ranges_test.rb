# frozen_string_literal: true

require "test_helper"

class ReferenceRangesTest < ActiveSupport::TestCase
  setup do
    @accession = accessions(:accession)
    @accession.update(lab_tests: [ lab_tests(:hgb) ])
    @patient = @accession.patient
  end

  # Hemoglobin [Mass/volume] in Blood
  #
  # Reference Ranges
  # Males:
  # (hgb_m1)  =<14D:......13.9-19.1 g/dL
  # (hgb_m2)  15D-4W:.....10.0-15.3 g/dL
  # (hgb_m3)  5W-7W:.......8.9-12.7 g/dL
  # (hgb_m4)  8W-5M:.......9.6-12.4 g/dL
  # (hgb_m5)  6M-23M:.....10.1-12.5 g/dL
  # (hgb_m6)  24M-35M:....10.2-12.7 g/dL
  # (hgb_m7)  3Y-5Y:......11.4-14.3 g/dL
  # (hgb_m8)  6Y-8Y:......11.5-14.3 g/dL
  # (hgb_m9)  9Y-10Y:.....11.8-14.7 g/dL
  # (hgb_m10) 11Y-14Y:....12.4-15.7 g/dL
  # (hgb_m11) 15Y-17Y:....12.4-15.7 g/dL
  # (hgb_m12) >=18Y:......13.2-16.6 g/dL
  test "single reference range per observation" do
    observation = Observation.create(lab_test: lab_tests(:hgb), accession: @accession)

    subjects = [
      { age: 1.day,                reference_ranges: [ qualified_intervals(:hgb_m1) ] },
      { age: 14.days,              reference_ranges: [ qualified_intervals(:hgb_m1) ] },
      { age: 14.days + 23.hours,   reference_ranges: [ qualified_intervals(:hgb_m1) ] },
      { age: 15.days,              reference_ranges: [ qualified_intervals(:hgb_m2) ] },
      { age: 17.years,             reference_ranges: [ qualified_intervals(:hgb_m11) ] },
      { age: 17.years + 11.months, reference_ranges: [ qualified_intervals(:hgb_m11) ] },
      { age: 18.years,             reference_ranges: [ qualified_intervals(:hgb_m12) ] }
    ]

    subjects.each do |subject|
      @patient.update(birthdate: subject[:age].ago)

      assert_equal subject[:reference_ranges],
                   observation.qualified_intervals.for_subject(@patient).for_age(subject[:age]).reference, "Subject age: #{subject[:age].iso8601}"
    end
  end

  # Hemoglobin [Mass/volume] in Blood
  #
  # Reference Ranges
  # Males:
  # (hgb_m12) >=18Y:......13.2-16.6 g/dL
  test "single reference range interpretation" do
    @patient.update(birthdate: 25.years.ago)
    observation = Observation.create(lab_test: lab_tests(:hgb), accession: @accession)

    interpretations = [
      { value: 13.1, flag: "L" },
      { value: 13.2, flag: "N" },
      { value: 16.6, flag: "N" },
      { value: 16.7, flag: "H" }
    ]

    interpretations.each do |interpretation|
      observation.update(value: interpretation[:value])

      assert_equal interpretation[:flag], observation.interpretation, "Value: #{interpretation[:value]}"
    end
  end

  # Follitropin [Units/volume] in Serum or Plasma
  #
  # Reference Ranges
  # Males:
  # (fsh_m1)  <12M:..........=<3.3 IU/L
  # (fsh_m2)  1Y-5Y:.........=<1.9 IU/L
  # (fsh_m3)  6Y-10Y:........=<2.3 IU/L
  # (fsh_m4)  11Y-15Y:.....0.6-6.9 IU/L
  # (fsh_m5)  16Y-18Y:.....0.7-9.6 IU/L
  # (fsh_m6)  >18Y:.......1.2-15.8 IU/L
  # (fsh_mt1) Tanner I:.......<1.5 IU/L
  # (fsh_mt2) Tanner II:......<3.0 IU/L
  # (fsh_mt3) Tanner II:...0.4-6.2 IU/L
  # (fsh_mt4) Tanner IV:...0.6-5.1 IU/L
  # (fsh_mt5) Tanner V:....0.8-7.2 IU/L
  test "multiple reference ranges per observation" do
    observation = Observation.create(lab_test: lab_tests(:fsh), accession: @accession)
    tanner_intervals = [
      qualified_intervals(:fsh_mt1),
      qualified_intervals(:fsh_mt2),
      qualified_intervals(:fsh_mt3),
      qualified_intervals(:fsh_mt4),
      qualified_intervals(:fsh_mt5)
    ]

    subjects = [
      { age: 11.months,            reference_ranges: [ qualified_intervals(:fsh_m1) ] + tanner_intervals },
      { age: 1.year,               reference_ranges: [ qualified_intervals(:fsh_m2) ] + tanner_intervals },
      { age: 18.years,             reference_ranges: [ qualified_intervals(:fsh_m5) ] + tanner_intervals },
      { age: 18.years + 11.months, reference_ranges: [ qualified_intervals(:fsh_m5) ] + tanner_intervals },
      { age: 19.years,             reference_ranges: [ qualified_intervals(:fsh_m6) ] }
    ]

    subjects.each do |subject|
      @patient.update!(birthdate: subject[:age].ago)

      assert_equal subject[:reference_ranges],
                   observation.qualified_intervals.for_subject(@patient).for_age(subject[:age]).reference, "Subject age: #{subject[:age].iso8601}"
    end
  end

  # Follitropin [Units/volume] in Serum or Plasma
  #
  # Reference Ranges
  # Males:
  # (fsh_m4)  11Y-15Y:.....0.6-6.9 IU/L
  # (fsh_mt1) Tanner I:.......<1.5 IU/L
  # (fsh_mt2) Tanner II:......<3.0 IU/L
  # (fsh_mt3) Tanner II:...0.4-6.2 IU/L
  # (fsh_mt4) Tanner IV:...0.6-5.1 IU/L
  # (fsh_mt5) Tanner V:....0.8-7.2 IU/L
  test "interpretation of multiple reference ranges" do
    @patient.update(birthdate: 13.years.ago)
    observation = Observation.create(lab_test: lab_tests(:fsh), accession: @accession)

    interpretations = [
      { value: 3.8, flag: "N" },
      { value: 0.5, flag: "N" },
      { value: 7.0, flag: "N" },
      { value: 7.3, flag: "H" }
    ]

    interpretations.each do |interpretation|
      observation.update(value: interpretation[:value])

      assert_equal interpretation[:flag], observation.interpretation, "Value: #{interpretation[:value]}"
    end
  end

  # Follitropin [Units/volume] in Serum or Plasma
  #
  # Reference Ranges
  # Females:
  # (fsh_ff) Follicular Stage:....2.9-14.6  IU/L
  # (fsh_fm) MidCycle:............4.7-23.2  IU/L
  # (fsh_fl) Luteal:..............1.4-8.9   IU/L
  # (fsh_fp) Post-Menopause:.....16.0-157.0 IU/L
  # Endocrine ranges should be taken into consideration when interpreting the result.
  # postmenopause interval was defined as >= 19Y.
  test "interpretation of multiple endocrine reference ranges" do
    @patient.update(gender: "F", birthdate: 45.years.ago)
    observation = Observation.create(lab_test: lab_tests(:fsh), accession: @accession)

    interpretations = [
      { value: 1.3,   flag: "L" },
      { value: 1.4,   flag: "N" },
      { value: 157.0, flag: "N" },
      { value: 157.1, flag: "H" }
    ]

    interpretations.each do |interpretation|
      observation.update(value: interpretation[:value])

      assert_equal interpretation[:flag], observation.interpretation, "Value: #{interpretation[:value]}"
    end
  end

  test "half-bounded intervals" do
    # Reference Range:............<10
    observation = Observation.create(lab_test: lab_tests(:qualified_interval_less_than),
                                     accession: @accession)

    interpretations = [
      { value: 9, flag: "N" },
      { value: 10, flag: "H" }
    ]

    interpretations.each do |interpretation|
      observation.update(value: interpretation[:value])

      assert_equal interpretation[:flag], observation.interpretation, "Value: #{interpretation[:value]} < 10"
    end

    # Reference Range:............>=10
    observation = Observation.create(lab_test: lab_tests(:qualified_interval_greater_than),
                                     accession: @accession)

    interpretations = [
      { value: 9,  flag: "L" },
      { value: 10, flag: "N" }
    ]

    interpretations.each do |interpretation|
      observation.update(value: interpretation[:value])

      assert_equal interpretation[:flag], observation.interpretation, "Value: #{interpretation[:value]} >= 10"
    end
  end
end
