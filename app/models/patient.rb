# frozen_string_literal: true

class Patient < ApplicationRecord
  include PgSearch

  ANIMAL_SPECIES = (0..3).to_a
  GENDERS = %w[F M U].freeze

  belongs_to :insurance_provider, optional: true

  has_many :accessions, dependent: :destroy
  has_many :notes, as: :noticeable

  validates :animal_type, inclusion: { in: ANIMAL_SPECIES }, allow_blank: true
  validates :gender, inclusion: { in: GENDERS }
  validates :given_name, :family_name, presence: true, length: { minimum: 2 }
  validates :birthdate, presence: true, not_in_the_future: true
  validates :identifier, uniqueness: true, allow_blank: true
  validates :email, email: true, allow_blank: true

  accepts_nested_attributes_for :accessions, allow_destroy: true

  scope :recent, -> { order(updated_at: :desc).limit(10) }
  scope :sorted, -> { order('LOWER(my_unaccent(family_name))') }
  scope :ordered, ->(order) { order(order.flatten.first || 'created_at DESC') }

  auto_strip_attributes :given_name, :middle_name, :family_name, :family_name2,
                        :identifier, :phone, :address, :policy_number

  before_save :titleize_names
  after_commit :flush_cache

  pg_search_scope :search_by_name, against: %i[identifier
                                               family_name family_name2
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
    Rails.cache.fetch([name, 'recent']) do
      recent.to_a
    end
  end

  private

  def titleize_names
    self.given_name = given_name.mb_chars.titleize if given_name
    self.middle_name = middle_name.mb_chars.titleize if middle_name
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'recent'])
  end
end
