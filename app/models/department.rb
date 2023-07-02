# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :lab_tests, -> { order(position: :asc) }, dependent: :destroy
  has_many :accessions, through: :lab_tests
  has_many :observations, through: :lab_tests
  has_many :notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  acts_as_list

  default_scope { order(position: :asc) }
  scope :sorted, -> { order(name: :asc) }

  auto_strip_attributes :code, :loinc_class, :name

  after_commit :flush_cache
  after_create_commit -> { broadcast_prepend_later_to 'admin:departments', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_departments_path } }
  after_update_commit -> { broadcast_replace_later_to 'admin:departments' }
  after_destroy_commit -> { broadcast_remove_to 'admin:departments' }

  after_update_commit -> { broadcast_replace_later_to 'admin:department', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_department_path(self) }, target: :department }
  after_destroy_commit -> { broadcast_replace_to 'admin:department', partial: 'layouts/invalid', locals: { path: Rails.application.routes.url_helpers.admin_departments_path }, target: :department }

  def self.cached_tests
    Rails.cache.fetch([name, 'cached_tests']) do
      order('id asc').includes(:lab_tests).to_a
    end
  end

  def to_partial_path
    'admin/departments/department'
  end

  private

  def flush_cache
    Rails.cache.delete([self.class.name, 'cached_tests'])
  end
end
