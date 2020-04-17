# frozen_string_literal: true

class Claim < ApplicationRecord
  belongs_to :accession, -> { includes :patient }, inverse_of: :claim
  belongs_to :insurance_provider

  has_one :patient, through: :accession

  validates :external_number, :number, uniqueness: true, allow_blank: true
  validates :accession, :insurance_provider, presence: true

  default_scope { order(external_number: :asc) }

  scope :submitted, -> { where.not(claimed_at: nil) }
  scope :recent, -> { where('claimed_at > :grace_period', grace_period: 8.months.ago) }

  def insured_name
    patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if Regexp.last_match(1) && Regexp.last_match(2)
      # XXX: Collapse into one Regexp
      Patient.find_by(policy_number: Regexp.last_match(1)) ||
        Patient.find_by(policy_number: "#{Regexp.last_match(1)}-0") ||
        Patient.find_by(policy_number: "#{Regexp.last_match(1)}-00") ||
        patient
    else
      patient
    end
  end

  def insured_policy_number
    insured_name.policy_number || 'pend.'
  end

  def valid_submission?
    return false if number.blank? || external_number.blank?

    true
  end
end
