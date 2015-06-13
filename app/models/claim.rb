class Claim < ActiveRecord::Base
  belongs_to :accession, inverse_of: :claim
  belongs_to :insurance_provider, inverse_of: :claims

  validates_uniqueness_of :number, :allow_blank => true
  validates_uniqueness_of :external_number, :allow_blank => true
  validates_presence_of :accession, :insurance_provider

  default_scope { order(external_number: :asc) }
  scope :submitted, -> { where.not(claimed_at: nil) }# include: {accession: :patient}
  scope :recent, -> { where('claimed_at > :grace_period', { grace_period: 5.months.ago }) }

  def insured_name
    accession.patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if $1 && $2
      Patient.find_by_policy_number($1) || accession.patient
    else
      accession.patient
    end
  end

  def insured_policy_number
    accession.patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if $1 && $2
      Patient.find_by_policy_number($1).try(:policy_number) || accession.patient.policy_number
    else
      accession.patient.policy_number || "pend."
    end
  end

  def valid_submission?
    return false if number.blank? || external_number.blank?
    true
  end
end
