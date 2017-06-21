# frozen_string_literal: true

class Doctor < ApplicationRecord
  has_many :accessions, dependent: :nullify

  validates :email, email: true, allow_blank: true
  validates :name,
    presence: true,
    uniqueness: true,
    length: { minimum: 2 }

  auto_strip_attributes :name

  after_commit :flush_cache

  default_scope { order(name: :asc) }

  def self.cached_doctors_list
    Rails.cache.fetch('doctors') { all.map(&:name).to_a }
  end

  private

  def flush_cache
    Rails.cache.delete('doctors')
  end
end
