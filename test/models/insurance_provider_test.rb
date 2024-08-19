# frozen_string_literal: true

require "test_helper"

class InsuranceProviderTest < ActiveSupport::TestCase
  test "presence of name" do
    insurance_provider = InsuranceProvider.create(name: "")
    assert insurance_provider.errors.added?(:name, :blank)
  end

  test "uniqueness of name" do
    insurance_provider = InsuranceProvider.create(name: "AXA")
    assert insurance_provider.errors.added?(:name, :taken, value: "AXA")
  end

  test "name contains extra spaces" do
    insurance_provider = InsuranceProvider.create(name: "  Insurance Provider  ")
    assert_equal "Insurance Provider", insurance_provider.name
  end

  test "no extra spaces between names" do
    insurance_provider = InsuranceProvider.create(name: "Insurance  Provider")
    assert_equal "Insurance Provider", insurance_provider.name
  end
end
