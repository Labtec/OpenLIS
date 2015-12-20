class PriceList < ApplicationRecord
  has_many :prices, inverse_of: :price_list, dependent: :nullify
  has_many :insurance_providers, inverse_of: :price_list, dependent: :nullify

  validates :name, uniqueness: true

  scope :grouped, -> { group(:name) }
end
