# frozen_string_literal: true

class Doctor < ApplicationRecord
  GENDERS = %w[male female other unkwown].freeze

  has_many :accessions, dependent: :nullify
  has_many :quotes, dependent: :nullify

  validates :email, email: true, allow_blank: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :name,
            cant_begin_with_dr: true,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2 }

  auto_strip_attributes :gender, :name, :email

  after_commit :flush_cache

  default_scope { order(name: :asc) }

  after_create_commit -> { broadcast_prepend_later_to 'admin:doctors', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_doctors_path } }
  after_update_commit -> { broadcast_replace_later_to 'admin:doctors' }
  after_destroy_commit -> { broadcast_remove_to 'admin:doctors' }

  def self.cached_doctors_list
    Rails.cache.fetch('doctors') { all.map(&:name).to_a }
  end

  def to_partial_path
    'admin/doctors/doctor'
  end

  private

  def flush_cache
    Rails.cache.delete('doctors')
  end
end
