# frozen_string_literal: true

class PriceList < ApplicationRecord
  has_many :prices, dependent: :nullify
  has_many :insurance_providers, dependent: :nullify
  has_many :quotes, dependent: :destroy

  validates :name, uniqueness: true

  scope :grouped, -> { group(:name) }
end
