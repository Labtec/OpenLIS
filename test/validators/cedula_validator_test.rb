# frozen_string_literal: true

require 'test_helper'

class CedulaValidatorTest < ActiveSupport::TestCase
  test 'valid cedula format' do
    p = patients(:john)

    p.identifier = 'E-8-123-456'
    assert p.invalid?, 'Cedula should be invalid'
    assert p.errors[:identifier].any?,
           'A patient with an invalid cedula should contain an error'
    assert_equal ['is invalid'], p.errors['identifier'],
                 'An invalid cedula error message is expected'

    p.identifier = '8-1234-56'
    assert p.invalid?, 'Folio/imagen cannot contain more than 3 characters'
    p.identifier = '8-123-456789'
    assert p.invalid?, 'Asiento/ficha cannot contain more than 5 characters'
    p.identifier = '8-123-45678'
    assert p.valid?, 'Cedula should be valid'
    p.identifier = 'E-8-12345'
    assert p.valid?, 'Cedula should be valid'
  end
end
