class InsuranceProvider < ActiveRecord::Base
  # Consider caching this model
  belongs_to :price_list
  has_many :patients
  has_many :prices, through: :price_list
  has_many :claims

  def submitted_claims
    claims.submitted
  end

  def unsubmitted_claims
    unsubmitted_claims = []
    all_unsubmitted_claims = Accession.find(Accession.with_insurance_provider.map(&:id) - Claim.submitted.map(&:accession_id)) #, include: :patient)
    all_unsubmitted_claims.each do |claim|
      unsubmitted_claims.push(claim) if claim.patient.insurance_provider == self
    end
    unsubmitted_claims
  end
end
