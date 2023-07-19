# frozen_string_literal: true

class Quote < ApplicationRecord
  include QuoteVersionConcerns

  VALIDITY_DURATION = 30.days

  self.implicit_order_column = 'created_at'

  enum :status, {
    draft: 0,
    needs_review: 1,
    in_review: 2,
    approved: 3,
    rejected: 4,
    presented: 5,
    accepted: 6,
    denied: 7,
    archived: 8
  }, default: :draft

  belongs_to :approved_by, optional: true, inverse_of: :quotes, class_name: 'User'
  belongs_to :created_by, inverse_of: :quotes, class_name: 'User'
  belongs_to :price_list
  belongs_to :patient, optional: true
  belongs_to :doctor, counter_cache: true, optional: true
  belongs_to :service_request, optional: true, inverse_of: :quote, class_name: 'Accession'
  belongs_to :parent_quote, optional: true, class_name: 'Quote'

  has_many :line_items, class_name: 'QuoteLineItem', dependent: :destroy
  has_many :lab_tests, -> { order('position ASC') }, through: :line_items, source: :item, source_type: 'LabTest'
  has_many :panels, through: :line_items, source: :item, source_type: 'Panel'
  has_many :versions, class_name: 'Quote', foreign_key: :parent_quote_id, dependent: :destroy

  accepts_nested_attributes_for :line_items

  delegate :age, to: :patient, prefix: true, allow_nil: true
  delegate :email, to: :patient, allow_nil: true
  delegate :gender, to: :patient, prefix: true, allow_nil: true
  delegate :identifier_type, to: :patient, prefix: true, allow_nil: true
  delegate :name, to: :doctor, prefix: true, allow_nil: true

  validates :serial_number, presence: true
  validates :version_number, presence: true, if: -> { parent_quote_id.present? },
                             uniqueness: { scope: [:parent_quote_id] }

  validate :at_least_one_panel_or_test_selected

  scope :recent, -> { order(created_at: :desc) }

  before_validation :set_price_list # TODO: Add GUI
  before_validation :add_serial_number, on: :create
  before_validation :add_version_number, on: :create

  auto_strip_attributes :note

  def doctor_name=(name)
    name = name.squish if name
    if name.blank?
      self.doctor_id = nil
    else
      self.doctor = Doctor.where(name: name).first_or_create
    end
  end

  def approved!
    self.approved_at = Time.zone.now
    self.expires_at = VALIDITY_DURATION.from_now
    super
  end

  def expired?
    Time.zone.now > expires_at
  end

  def grand_total
    total_price + shipping_and_handling
  end

  def last_version?
    return true unless parent_quote

    parent_quote.versions.last == self ? true : false
  end

  def last_version_number
    parent_quote.try(:versions).try(:last).try(:version_number).to_i
  end

  def panels_lab_test_ids
    (LabTestPanel.where(panel_id: panel_ids).map(&:lab_test_id) + lab_test_ids).uniq
  end

  # Retiree discount eligibility
  def patient_retiree?
    return false unless patient_identifier_type == 1 # cedula

    return true if patient_gender == 'F' && patient_age >= 55.years
    return true if patient_gender == 'M' && patient_age >= 60.years

    false
  end

  def subtotal
    line_items.sum(&:subtotal)
  end

  def items_list
    line_items.map(&:item).pluck(:code)
  end

  def total_discount
    line_items.sum(&:total_discount)
  end

  def total_price
    line_items.sum(&:total_price)
  end

  private

  def add_serial_number
    self.serial_number = parent_quote ? parent_quote.serial_number : Time.now.to_fs(:number).to_i
  end

  def add_version_number
    return unless parent_quote

    self.version_number = last_version_number + 1
  end

  def at_least_one_panel_or_test_selected
    return unless panel_ids.blank? && lab_test_ids.blank?

    errors.add(:base, I18n.t('flash.accessions.at_least_one_panel_or_test_selected'))
  end

  def set_price_list
    self.price_list_id = PriceList.last.id
  end
end
