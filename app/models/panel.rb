# frozen_string_literal: true

class Panel < ApplicationRecord
  has_many :lab_test_panels, dependent: :destroy
  has_many :lab_tests, through: :lab_test_panels
  has_many :accession_panels, dependent: :destroy
  has_many :accessions, through: :accession_panels
  has_many :prices, as: :priceable, dependent: :destroy

  accepts_nested_attributes_for :prices, allow_destroy: true

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true

  scope :with_price, -> { includes(:prices).where.not(prices: { amount: nil }) }
  scope :sorted, -> { order(name: :asc) }

  auto_strip_attributes :name, :code, :procedure, :loinc

  def lab_test_code_list
    LabTest.where(id: lab_test_ids).map(&:code).join(', ')
  end

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end
end
