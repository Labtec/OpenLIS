# frozen_string_literal: true

require 'test_helper'

class NotTooOldValidatorTest < ActiveSupport::TestCase
  test 'valid birth date' do
    p = patients(:john)

    p.birthdate = 500.years.ago
    assert p.invalid?, 'Birth date should be invalid'
    assert p.errors[:birthdate].any?,
           'A patient with an invalid birth date should contain an error'
    assert_equal ['cannot be that old'], p.errors['birthdate'],
                 'An invalid birth date error message is expected'

    p.birthdate = 30.years.ago
    assert p.valid?, 'Birth date should be valid'
  end
end
