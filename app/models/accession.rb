# frozen_string_literal: true

class Accession < ApplicationRecord
  belongs_to :patient, touch: true
  belongs_to :doctor, counter_cache: true, optional: true
  belongs_to :receiver, inverse_of: :accessions, class_name: 'User'
  belongs_to :drawer, inverse_of: :accessions, class_name: 'User'
  belongs_to :reporter, optional: true, inverse_of: :accessions, class_name: 'User'

  has_many :results, dependent: :destroy
  has_many :lab_tests, through: :results
  has_many :accession_panels, dependent: :destroy
  has_many :panels, through: :accession_panels
  has_many :notes, as: :noticeable, dependent: :destroy

  has_one :claim, dependent: :destroy
  has_one :insurance_provider, through: :patient

  delegate :birthdate, to: :patient, prefix: true
  delegate :name, to: :doctor, prefix: true, allow_nil: true
  delegate :external_number, to: :claim, prefix: true, allow_nil: true
  delegate :number, to: :claim, prefix: true, allow_nil: true

  accepts_nested_attributes_for :results, allow_destroy: true
  accepts_nested_attributes_for :accession_panels, allow_destroy: true
  accepts_nested_attributes_for :notes, allow_destroy: true, reject_if: :reject_notes

  validates :icd9, presence: true, if: :insurable?
  validates :drawn_at, :received_at, presence: true
  validates :drawn_at, :received_at, :reported_at, not_in_the_future: true
  validate :at_least_one_panel_or_test_selected

  scope :recently, -> { order(reported_at: :desc) }
  scope :queued, -> { order(drawn_at: :asc) }
  scope :ordered, -> { order(id: :asc) }
  scope :pending, -> { where(reported_at: nil) }
  scope :reported, -> { where.not(reported_at: nil) }
  scope :with_insurance_provider, -> { joins(:patient).where('patients.insurance_provider_id IS NOT NULL').ordered }
  scope :within_claim_period, -> { where('drawn_at > :claim_period', claim_period: 8.months.ago) }
  scope :unclaimed, -> { eager_load(:claim).where('claims.claimed_at IS NULL').ordered }

  def result_attributes=(result_attributes)
    results.reject(&:new_record?).each do |result|
      next if result.lab_test.derivation
      attributes = result_attributes[result.id.to_s]
      if attributes['_delete'] == '1'
        results.delete(result)
      else
        result.attributes = attributes
      end
    end
  end

  def patient_age
    sec_per_day = 86_400
    days_per_week = 7
    days_per_month = 30.4368
    days_per_year = 365.242

    age_in_days = (drawn_at - patient_birthdate.to_time(:local)) / sec_per_day
    age_in_weeks = ((age_in_days / days_per_week) * 10).round / 10
    age_in_months = ((age_in_days / days_per_month) * 10).round / 10
    age_in_years = (age_in_days / days_per_year).floor
    age_in_days = (age_in_days * 10).round / 10

    { days: age_in_days, weeks: age_in_weeks, months: age_in_months, years: age_in_years }
  end

  def doctor_name=(name)
    name = name.squish if name
    if name.blank?
      self.doctor_id = nil
    else
      self.doctor = Doctor.where(name: name).first_or_create
    end
  end

  def insurable?
    insurance_provider && doctor.present?
  end

  def order_list
    (panels_list + lab_tests_list).join(', ')
  end

  def pending_list
    results.map do |result|
      result.lab_test_code if result.pending?
    end.compact.join(', ')
  end

  def pending_claim?
    true if patient.insurance_provider && !claim.try(:claimed_at)
  end

  def complete?
    results.includes(:lab_test).each do |result|
      return false if result.pending?
    end
    true
  end

  private

  def panels_list
    Panel.find(panel_ids).map(&:code)
  end

  def lab_tests_list
    panels_lab_tests_list_ids = LabTestPanel.where(panel_id: panel_ids).map(&:lab_test_id).uniq
    LabTest.find(lab_test_ids - panels_lab_tests_list_ids).map(&:code)
  end

  def result_of_test_coded_as(code)
    results.find_by(lab_test_id: LabTest.find_by(code: code)).try(:value).try(:to_d)
  end

  def reject_notes(attributes)
    attributes[:content].blank? if new_record?
  end

  def at_least_one_panel_or_test_selected
    errors.add(:base, I18n.t('flash.accessions.at_least_one_panel_or_test_selected')) if panel_ids.blank? && lab_test_ids.blank?
  end
end
