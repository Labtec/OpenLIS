# frozen_string_literal: true

class PriceList < ApplicationRecord
  has_many :prices, dependent: :nullify
  has_many :insurance_providers, dependent: :nullify

  validates :name, uniqueness: true

  scope :grouped, -> { group(:name) }
end
