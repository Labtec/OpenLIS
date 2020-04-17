# frozen_string_literal: true

require 'test_helper'

class ClaimTest < ActiveSupport::TestCase
  test 'insured_name with existing policyholder' do
    policyholder = patients(:john)
    policyholder.insurance_provider = insurance_providers(:axa)
    policyholder.policy_number = '1234'
    policyholder.save!
    claim = claims(:axa)
    claim.patient.policy_number = '1234-02'

    assert_equal policyholder, claim.insured_name

    policyholder.policy_number = '1234-0'
    policyholder.save!

    assert_equal policyholder, claim.insured_name

    policyholder.policy_number = '1234-00'
    policyholder.save!

    assert_equal policyholder, claim.insured_name
  end

  test 'insured_name with non-existing policyholder' do
    claim = claims(:axa)
    claim.patient.policy_number = '1234-02'

    assert_equal patients(:insured), claim.insured_name
  end

  test 'insured_policy_number with existing policyholder' do
    policyholder = patients(:john)
    policyholder.insurance_provider = insurance_providers(:axa)
    policyholder.policy_number = '1234'
    policyholder.save!
    claim = claims(:axa)
    claim.patient.policy_number = '1234-02'

    assert_equal '1234', claim.insured_policy_number

    policyholder.policy_number = '1234-0'
    policyholder.save!

    assert_equal '1234-0', claim.insured_policy_number

    policyholder.policy_number = '1234-00'
    policyholder.save!

    assert_equal '1234-00', claim.insured_policy_number
  end

  test 'insured_policy_number with non-existing policyholder' do
    claim = claims(:axa)
    claim.patient.policy_number = '1234-02'

    assert_equal '1234-02', claim.insured_policy_number
  end

end
