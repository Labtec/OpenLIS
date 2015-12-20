class Patient < ApplicationRecord
  include PgSearch

  ANIMAL_TYPES = (0..3).to_a
  GENDERS = %w(F M U).freeze

  belongs_to :insurance_provider, inverse_of: :patients

  has_many :accessions, inverse_of: :patient, dependent: :destroy
  has_many :notes, as: :noticeable

  validates :animal_type, inclusion: { in: ANIMAL_TYPES }, allow_blank: true
  validates :gender, inclusion: { in: GENDERS }
  validates :given_name, :family_name, :birthdate, presence: true
  validates :identifier, uniqueness: true, allow_blank: true
  validates :email, email: true, allow_blank: true
  validate :birthdate_cant_be_in_the_future

  accepts_nested_attributes_for :accessions, allow_destroy: true

  scope :recent, -> { order(updated_at: :desc).limit(10) }
  scope :sorted, -> { order('LOWER(my_unaccent(family_name))') }
  scope :ordered, ->(order) { order(order.flatten.first || 'created_at DESC') }

  before_save :titleize_names

  after_commit :flush_cache

  pg_search_scope :search_by_name, against: %i(identifier
                                               family_name family_name2
                                               given_name middle_name),
                                   ignoring: :accents

  def self.search(query)
    if query.present?
      search_by_name(query)
    else
      all.sorted
    end
  end

  def self.cached_recent
    Rails.cache.fetch([name, 'recent']) do
      recent.to_a
    end
  end

  private

  def birthdate_cant_be_in_the_future
    errors.add(:birthdate, I18n.t('flash.patient.birthday_cant_be_in_the_future')) if birthdate > Date.current unless birthdate.nil?
  end

  def titleize_names
    self.given_name = given_name.mb_chars.titleize.squish if given_name
    self.middle_name = middle_name.mb_chars.titleize.squish if middle_name
    self.family_name = family_name.squish if family_name
    self.family_name2 = family_name2.squish if family_name2
    self.identifier = identifier.squish if identifier
    self.phone = phone.squish if phone
    self.address = address.squish if address
    self.policy_number = policy_number.squish if policy_number
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'recent'])
  end
end
