# frozen_string_literal: true

class WebauthnCredential < ApplicationRecord
  MAX_COUNTER = (2**32) - 1

  belongs_to :user

  validates :external_id, :public_key, :nickname, :sign_count, presence: true
  validates :external_id, uniqueness: true
  validates :nickname, uniqueness: { scope: :user_id }
  validates :sign_count, numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: MAX_COUNTER }

  auto_strip_attributes :nickname
end
