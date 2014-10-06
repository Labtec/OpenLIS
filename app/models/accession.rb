class Accession < ActiveRecord::Base
  belongs_to :patient
  belongs_to :doctor
  belongs_to :receiver, class_name: 'User'
  belongs_to :drawer, class_name: 'User'
  belongs_to :reporter, class_name: 'User'
  has_many :results, dependent: :destroy
  has_many :lab_tests, through: :results
  has_many :accession_panels, dependent: :destroy
  has_many :panels, through: :accession_panels
  has_many :notes, as: :noticeable
  has_one :claim, dependent: :destroy

  accepts_nested_attributes_for :results, allow_destroy: true
  accepts_nested_attributes_for :accession_panels, allow_destroy: true
  accepts_nested_attributes_for :notes, allow_destroy: true, reject_if: lambda { |a| a[:content].blank? }, allow_destroy: true

  validates_presence_of :patient_id
  validates_presence_of :icd9, if: Proc.new { |accession| accession.patient.try(:insurance_provider) }
  validates_presence_of :drawn_at
  validates_presence_of :received_at
  validate :at_least_one_panel_or_test_selected
  validate :drawn_at_cant_be_in_the_future
  validate :received_at_cant_be_in_the_future
  validate :reported_at_cant_be_in_the_future

  scope :recently, -> { order(updated_at: :desc) }
  scope :queued, -> { order(drawn_at: :asc) }
  scope :pending, -> { where(reported_at: nil) } #, include: [{results: [:lab_test, :lab_test_value]}, :drawer, :doctor]
  scope :reported, -> { where.not(reported_at: nil) } #, include: [:lab_tests, :panels, :reporter, :doctor]
  scope :with_insurance_provider, -> {
    select("accessions.*")
      .joins("INNER JOIN patients ON patients.id = accessions.patient_id")
      .where("patients.insurance_provider_id IS NOT NULL")
      .order(id: :asc)
  }
  scope :within_claim_period, -> { where('drawn_at > :claim_period', { claim_period: 4.months.ago }) }

  #after_update :save_results

  def result_attributes=(result_attributes)
    results.reject(&:new_record?).each do |result|
      unless result.lab_test.derivation
        attributes = result_attributes[result.id.to_s]
        if attributes['_delete'] == '1'
          results.delete(result)
        else
          result.attributes = attributes
        end
      end
    end
  end

  def patient_age
    sec_per_day = 86400
    days_per_week = 7
    days_per_month = 30.4368 #30.4375
    days_per_year = 365.242 #365.24

    age_in_days = (drawn_at - patient.birthdate.to_time) / sec_per_day
    age_in_weeks = ((age_in_days / days_per_week) * 10).round / 10
    age_in_months = ((age_in_days / days_per_month) * 10).round / 10
    age_in_years = (age_in_days / days_per_year).floor
    age_in_days = (age_in_days * 10).round / 10

    { days: age_in_days, weeks: age_in_weeks, months: age_in_months, years: age_in_years }
  end

  def patient_age_in_days
    (drawn_at.to_date - patient.birthdate).to_i
  end

  def doctor_name
    doctor.name if doctor
  end

  def doctor_name=(name)
    if name.blank?
      self.doctor_id = nil
    else
      self.doctor = Doctor.where(name: name).first_or_create
    end
  end

  def order_list
    panels_list = panels.map {|p| p.code}
    panels_lab_tests_list = panels.map {|p| p.lab_tests.map {|t| t.code}}
    panels_lab_tests_list = []
    all_lab_tests_list = lab_tests.map {|t| t.code}
    (panels_list + all_lab_tests_list - panels_lab_tests_list).join(', ')
  end

  def pending_list
    results.map { |result| result.lab_test.code if result.pending? }.compact.join(', ')
  end

  def pending_claim?
    true if patient.insurance_provider && !claim.try(:claimed_at)
  end

  def complete?
    results.each do |result|
      return false if result.formatted_value == "pend."
    end
    true
  end

private

  def drawn_at_cant_be_in_the_future
    errors.add(:drawn_at, I18n.t('flash.accession.cant_be_in_the_future')) if Time.now < drawn_at unless drawn_at.nil?
  end

  def received_at_cant_be_in_the_future
    errors.add(:received_at, I18n.t('flash.accession.cant_be_in_the_future')) if Time.now < received_at unless received_at.nil?
  end

  def reported_at_cant_be_in_the_future
    errors.add(:reported_at, I18n.t('flash.accession.cant_be_in_the_future')) if Time.now < reported_at unless reported_at.nil?
  end

  def result_of_test_coded_as(code)
    results.find_by_lab_test_id(lab_tests.with_code(code).first).try(:value).try(:to_d)
  end

  #def save_results
  #  results.each do |result|
  #    result.save(false)
  #  end
  #end

  def at_least_one_panel_or_test_selected
    if panel_ids.blank? && lab_test_ids.blank?
      errors.add(:base, I18n.t('flash.accessions.at_least_one_panel_or_test_selected'))
    end
  end
end
