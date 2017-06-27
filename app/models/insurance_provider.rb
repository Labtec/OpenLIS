# frozen_string_literal: true

class InsuranceProvider < ApplicationRecord
  belongs_to :price_list

  has_many :claims
  has_many :patients
  has_many :accessions, through: :patients
  has_many :prices, through: :price_list

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name
end
