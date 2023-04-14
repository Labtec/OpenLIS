# frozen_string_literal: true

class Claim < ApplicationRecord
  belongs_to :accession, -> { includes :patient }, inverse_of: :claim
  belongs_to :insurance_provider

  has_one :patient, through: :accession

  has_many :lab_tests, through: :accession
  has_many :panels, through: :accession

  validates :external_number, :number, uniqueness: true, allow_blank: true
  validates :accession, :insurance_provider, presence: true

  default_scope { order(external_number: :asc) }

  scope :submitted, -> { where.not(claimed_at: nil) }
  scope :recent, -> { where('claimed_at > :grace_period', grace_period: 8.months.ago) }

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

  def valid_submission?
    return false if number.blank? || external_number.blank?

    true
  end
end
