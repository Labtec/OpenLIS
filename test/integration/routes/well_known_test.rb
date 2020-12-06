# frozen_string_literal: true

require 'test_helper'

class WellKnownRoutesTest < ActionDispatch::IntegrationTest
  setup do
    @defaults = { controller: 'well_known' }
  end

  test 'routes change-password' do
    assert_routing '/.well-known/change-password', @defaults.merge(action: 'change_password')
  end
end
