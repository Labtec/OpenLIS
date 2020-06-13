# frozen_string_literal: true

require 'test_helper'

class EmailValidatorTest < ActiveSupport::TestCase
  test 'valid email format' do
    p = patients(:john)

    p.email = 'jnuñez@example.com'
    assert p.invalid?, 'Email should be invalid'
    assert p.errors[:email].any?,
           'A patient with an invalid email should contain an error'
    assert_equal ['is invalid'], p.errors['email'],
                 'An invalid email error message is expected'

    p.email = 'jnunez@example.com'
    assert p.valid?, 'Email should be valid'
  end
end
