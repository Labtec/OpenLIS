class Claim < ActiveRecord::Base
  belongs_to :accession
  belongs_to :insurance_provider

  validates_uniqueness_of :number, :allow_blank => true
  validates_uniqueness_of :external_number, :allow_blank => true
  validates_presence_of :accession

  default_scope :order => :external_number
  named_scope :submitted, :conditions => 'claimed_at IS NOT NULL', :include => {:accession => :patient}
  named_scope :recent, lambda { |time| { :conditions => ["claimed_at > ?", 5.months.ago] } }

  def insured_name
    accession.patient.try(:policy_number) =~ /(\d+)-(\d+)/
    if $1 && $2
      Patient.find_by_policy_number($1).try(:name_last_comma_first_mi) || accession.patient.name_last_comma_first_mi
    else
      accession.patient.name_last_comma_first_mi
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
