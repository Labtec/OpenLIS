class PriceList < ActiveRecord::Base
  has_many :prices, inverse_of: :price_list, dependent: :nullify
  has_many :insurance_providers, inverse_of: :price_list, dependent: :nullify

  validates_uniqueness_of :name

  scope :grouped, -> { group(:name) }
end
