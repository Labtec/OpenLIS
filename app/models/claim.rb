class Claim < ApplicationRecord
  belongs_to :accession, -> { includes :patient }
  belongs_to :insurance_provider

  has_one :patient, through: :accession

  validates :external_number, :number, uniqueness: true, allow_blank: true
  validates :accession, :insurance_provider, presence: true

  default_scope { order(external_number: :asc) }

  scope :submitted, -> { where.not(claimed_at: nil) }
  scope :recent, -> { where('claimed_at > :grace_period', { grace_period: 5.months.ago }) }

  def insured_name
    patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if $1 && $2
      Patient.find_by_policy_number($1) || patient
    else
      patient
    end
  end

  def insured_policy_number
    patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if $1 && $2
      Patient.find_by_policy_number($1).try(:policy_number) || patient.policy_number
    else
      patient.policy_number || 'pend.'
    end
  end

  def valid_submission?
    return false if number.blank? || external_number.blank?
    true
  end
end
