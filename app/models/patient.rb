# frozen_string_literal: true

class Patient < ApplicationRecord
  include PgSearch::Model
  include FHIRable::Patient

  ANIMAL_SPECIES = (0..3).to_a
  GENDERS = %w[F M O U].freeze
  IDENTIFIER_TYPES = (0..2).to_a

  belongs_to :insurance_provider, optional: true

  has_many :accessions, dependent: :destroy
  has_many :notes, as: :noticeable, dependent: :destroy

  store_accessor :address, :line, :corregimiento, :district, :province, prefix: true

  validates :animal_type, inclusion: { in: ANIMAL_SPECIES }, allow_blank: true
  validates :gender, inclusion: { in: GENDERS }
  validates :given_name, presence: true, length: { minimum: 2 }
  validates :family_name, presence: true,
                          length: { minimum: 2 },
                          unless: -> { partner_name.present? || animal_type.present? }
  validates :partner_name, presence: true,
                           length: { minimum: 2 },
                           unless: -> { family_name.present? || animal_type.present? }
  validates :birthdate, presence: true, unless: -> { animal_type.present? }
  validates :birthdate, not_in_the_future: true
  validates :identifier, uniqueness: { case_sensitive: false },
                         allow_blank: true
  validates :identifier_type, presence: true, if: -> { identifier.present? }
  validates :identifier_type, inclusion: { in: IDENTIFIER_TYPES },
                              allow_blank: true
  validates :email, email: true, allow_blank: true
  validates :phone, phone: { allow_blank: true, types: :fixed_line }
  validates :cellular, phone: { allow_blank: true, types: :mobile }
  validates :address_province, presence: true,
                               if: lambda {
                                     address_district.present? ||
                                       address_corregimiento.present? ||
                                       address_line.present?
                                   }, allow_blank: true
  validates :address_corregimiento, presence: true,
                                    if: lambda {
                                          address_province.present? ||
                                            address_line.present?
                                        }
  validates :address_line, presence: true,
                           if: -> { address_province.present? }
  # TODO: Add province, district and corregimiento validators
  # validates :address_province, province: true
  # validates :address_district, district: true
  # validates :address_corregimiento, corregimiento: true

  accepts_nested_attributes_for :accessions, allow_destroy: true

  scope :recent, -> { order(updated_at: :desc).limit(10) }
  scope :sorted, -> { order(Arel.sql('LOWER(my_unaccent(family_name))')) }
  scope :ordered, ->(order) { order(order.flatten.first || 'created_at DESC') }

  auto_strip_attributes :given_name, :middle_name, :family_name, :family_name2,
                        :partner_name, :identifier, :cellular, :phone,
                        :policy_number
  auto_strip_attributes :address_province, :address_district, :address_corregimiento,
                        :address_line, virtual: true

  before_save :titleize_names, :nil_identifier_type_if_identifier_blank,
              :nil_address_if_address_province_blank
  after_commit :flush_cache

  pg_search_scope :search_by_name, against: %i[identifier
                                               family_name family_name2
                                               partner_name
                                               given_name middle_name],
                                   ignoring: :accents

  def self.search(query)
    if query.present?
      search_by_name(query)
    else
      all.sorted
    end
  end

  def self.cached_recent
    Rails.cache.fetch([name, 'recent_patients']) do
      recent.to_a
    end
  end

  private

  def nil_address_if_address_province_blank
    self.address = nil if address_province.blank?
  end

  def nil_identifier_type_if_identifier_blank
    self.identifier_type = nil if identifier.blank?
  end

  def titleize_names
    self.given_name = given_name.mb_chars.titleize if given_name
    self.middle_name = middle_name.mb_chars.titleize if middle_name
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'recent_patients'])
  end
end
