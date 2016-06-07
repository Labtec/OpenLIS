class InsuranceProvider < ApplicationRecord
  belongs_to :price_list, inverse_of: :insurance_providers

  has_many :claims, inverse_of: :insurance_provider
  has_many :patients, inverse_of: :insurance_provider
  has_many :accessions, through: :patients
  has_many :prices, through: :price_list

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name
end
