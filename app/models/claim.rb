# frozen_string_literal: true

class Claim < ApplicationRecord
  belongs_to :accession, -> { includes :patient }, inverse_of: :claim
  belongs_to :insurance_provider

  has_one :patient, through: :accession

  has_many :lab_tests, through: :accession
  has_many :panels, through: :accession

  validates :external_number, :number, uniqueness: true, allow_blank: true

  default_scope { order(external_number: :asc) }

  scope :submitted, -> { where.not(claimed_at: nil) }
  scope :recent, -> { where('claimed_at > :grace_period', grace_period: 8.months.ago) }

  def cpt_codes
    procedures = []
    lab_tests_list = []

    # Panels Table
    panels.with_price.map do |panel|
      procedures << panel.procedure.to_s
    end

    # Lab Tests Table
    lab_tests.with_price.map do |lab_test|
      next if lab_test.prices.find_by(price_list_id: 1)&.amount.nil?

      lab_tests_list.push lab_test if (lab_test.panel_ids && panel_ids).empty?
    end

    lab_tests_list.map do |lab_test|
      procedures << lab_test.procedure.to_s
    end

    procedures
  end

  def insured_name
    patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if Regexp.last_match(1) && Regexp.last_match(2)
      insured_policy_number = "#{Regexp.last_match(1)}-00"
      Patient.find_by(policy_number: insured_policy_number) || patient
    else
      patient
    end
  end

  def insured_policy_number
    patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if Regexp.last_match(1) && Regexp.last_match(2)
      insured_policy_number = "#{Regexp.last_match(1)}-00"
      Patient.find_by(policy_number: insured_policy_number).try(:policy_number) || patient.policy_number
    else
      patient.policy_number || 'pend.'
    end
  end

  def to_partial_path
    'admin/claims/claim'
  end

  def total_price
    total_price = []
    lab_tests_list = []

    # Panels Table
    panels.with_price.map do |panel|
      total_price << panel.prices.find_by(price_list_id: 1)&.amount
    end

    # Lab Tests Table
    lab_tests.with_price.map do |lab_test|
      next if lab_test.prices.find_by(price_list_id: 1)&.amount.nil?

      lab_tests_list.push lab_test if (lab_test.panel_ids && panel_ids).empty?
    end

    lab_tests_list.map do |lab_test|
      total_price << lab_test.prices.find_by(price_list_id: 1)&.amount
    end

    total_price.sum
  end

  def valid_submission?
    return false if number.blank? || external_number.blank?

    true
  end
end
