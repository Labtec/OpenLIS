class Doctor < ApplicationRecord
  has_many :accessions, inverse_of: :doctor, dependent: :nullify

  validates :name,
    presence: true,
    uniqueness: true,
    length: { minimum: 2 }

  before_validation :purge_trailing_spaces

  after_commit :flush_cache

  default_scope { order(name: :asc) }

  def self.cached_doctors_list
    Rails.cache.fetch('doctors') { all.map(&:name).to_a }
  end

  private

  def flush_cache
    Rails.cache.delete('doctors')
  end

  def purge_trailing_spaces
    self.name = name.squish if name
  end
end
