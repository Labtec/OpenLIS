# frozen_string_literal: true

class PriceList < ApplicationRecord
  has_many :prices, dependent: :nullify
  has_many :insurance_providers, dependent: :nullify
  has_many :quotes, dependent: :destroy

  validates :name, uniqueness: true

  scope :grouped, -> { group(:name) }

  enum :status, {
    active: 0,
    archived: 1
  }, default: :active
end
