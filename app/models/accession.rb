# frozen_string_literal: true

class Accession < ApplicationRecord
  include Derivable
  include DiagnosticReportStatus
  include FHIRable::DiagnosticReport

  belongs_to :patient, touch: true
  belongs_to :doctor, counter_cache: true, optional: true
  belongs_to :receiver, inverse_of: :accessions, class_name: 'User'
  belongs_to :drawer, inverse_of: :accessions, class_name: 'User'
  belongs_to :reporter, optional: true, inverse_of: :accessions, class_name: 'User'

  has_one :claim, dependent: :destroy
  has_one :insurance_provider, through: :patient

  has_many :results, class_name: 'Observation', dependent: :destroy
  has_many :lab_tests, -> { order('position ASC') }, through: :results
  has_many :accession_panels, dependent: :destroy
  has_many :panels, through: :accession_panels
  has_many :departments, through: :lab_tests
  has_many :notes, as: :noticeable, dependent: :destroy

  delegate :birthdate, to: :patient, prefix: true
  delegate :name, to: :doctor, prefix: true, allow_nil: true
  delegate :external_number, to: :claim, prefix: true, allow_nil: true
  delegate :number, to: :claim, prefix: true, allow_nil: true

  accepts_nested_attributes_for :results, allow_destroy: true
  accepts_nested_attributes_for :accession_panels, allow_destroy: true
  accepts_nested_attributes_for :notes, allow_destroy: true

  validates :icd9, presence: true, if: :insurable?
  validates :drawn_at, :received_at, presence: true
  validates :drawn_at, :received_at, :reported_at, not_in_the_future: true
  validate :at_least_one_panel_or_test_selected

  scope :recently, -> { order(reported_at: :desc) }
  scope :queued, -> { order(drawn_at: :asc) }
  scope :ordered, -> { order(id: :asc) }
  scope :pending, -> { where(reported_at: nil) }
  scope :reported, -> { where.not(reported_at: nil) }
  scope :with_insurance_provider, -> { joins(:patient).where.not('patients.insurance_provider_id' => nil).ordered }
  scope :within_claim_period, -> { where('drawn_at > :claim_period', claim_period: 8.months.ago) }
  scope :unclaimed, -> { eager_load(:claim).where(claims: { claimed_at: nil }).ordered }
  scope :claimable, -> { where.not(doctor_id: nil) }

  before_save :nil_empty_notes
  after_create_commit -> { broadcast_prepend_later_to :accessions, partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.accessions_path } }
  after_update_commit -> { broadcast_replace_later_to :accessions }
  after_destroy_commit -> { broadcast_remove_to :accessions }

  after_update_commit -> { broadcast_replace_later_to :accession, partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.accession_path(self) }, target: :accession }
  after_destroy_commit -> { broadcast_replace_to :accession, partial: 'layouts/invalid', locals: { path: Rails.application.routes.url_helpers.accessions_path }, target: :accession }

  def subject_age
    ActiveSupport::Duration.age(patient_birthdate, drawn_at)
  end

  def doctor_name=(name)
    name = name.squish if name
    if name.blank?
      self.doctor_id = nil
    else
      self.doctor = Doctor.where(name: name).first_or_create
    end
  end

  def complete?
    return true if pending_tests.empty?

    false
  end

  def insurable?
    insurance_provider && doctor.present?
  end

  def lab_tests_list
    panels_lab_tests_list_ids = LabTestPanel.where(panel_id: panel_ids).map(&:lab_test_id).uniq
    LabTest.find(lab_test_ids - panels_lab_tests_list_ids).map(&:code)
  end

  def no_values?
    return false if results.preliminary.any?

    true
  end

  def panels_list
    Panel.find(panel_ids).map(&:code)
  end

  def pending_claim?
    true if patient.insurance_provider && !claim.try(:claimed_at)
  end

  def pending_tests
    results.includes(:lab_test).registered.map(&:lab_test_code)
  end

  def tests_list
    (panels_list + lab_tests_list)
  end

  private

  def nil_empty_notes
    notes.each do |note|
      note.destroy! if note.content.blank?
    end
  end

  def at_least_one_panel_or_test_selected
    if panel_ids.blank? && lab_test_ids.blank?
      errors.add(:base, I18n.t('flash.accessions.at_least_one_panel_or_test_selected'))
    end
  end
end
