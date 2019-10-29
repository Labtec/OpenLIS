# frozen_string_literal: true

require 'test_helper'

class WebauthnCredentialTest < ActiveSupport::TestCase
  setup do
    @webauthn_credential = webauthn_credentials(:webauthn_credential)
  end

  test 'presence of external_id' do
    @webauthn_credential.update(external_id: '')
    assert @webauthn_credential.errors.added?(:external_id, :blank)
  end

  test 'presence of public_key' do
    @webauthn_credential.update(public_key: '')
    assert @webauthn_credential.errors.added?(:public_key, :blank)
  end

  test 'presence of nickname' do
    @webauthn_credential.update(nickname: '')
    assert @webauthn_credential.errors.added?(:nickname, :blank)
  end

  test 'presence of sign_count' do
    @webauthn_credential.update(sign_count: '')
    assert @webauthn_credential.errors.added?(:sign_count, :blank)
  end

  test 'uniqueness of external_id' do
    external_id = @webauthn_credential.external_id
    webauthn_credential = WebauthnCredential.create(external_id: external_id)
    assert webauthn_credential.errors.added?(:external_id, :taken, value: external_id)
  end

  test 'uniqueness of nickname within user' do
    nickname = @webauthn_credential.nickname
    user = @webauthn_credential.user
    webauthn_credential = WebauthnCredential.create(user: user, nickname: nickname)
    assert webauthn_credential.errors.added?(:nickname, :taken, value: nickname)
  end

  test 'numericality of sign_count' do
    @webauthn_credential.update(sign_count: 'invalid')
    assert @webauthn_credential.errors.added?(:sign_count, :not_a_number, value: 'invalid')

    @webauthn_credential.update(sign_count: -1)
    assert @webauthn_credential.errors.added?(:sign_count, :greater_than_or_equal_to, value: -1, count: 0)

    @webauthn_credential.update(sign_count: 2**64 / 2)
    assert @webauthn_credential.errors.added?(:sign_count, :less_than_or_equal_to, value: 2**64 / 2, count: 2**64 / 2 - 1)
  end
end
