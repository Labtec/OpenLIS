# frozen_string_literal: true

require 'test_helper'

class InsuranceProviderTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)

  test 'name contains extra spaces' do
    insurance_provider = InsuranceProvider.create(name: '  Insurance Provider  ')
    assert_equal 'Insurance Provider', insurance_provider.name
  end

  test 'no extra spaces between names' do
    insurance_provider = InsuranceProvider.create(name: 'Insurance  Provider')
    assert_equal 'Insurance Provider', insurance_provider.name
  end
end
