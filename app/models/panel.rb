# frozen_string_literal: true

class Panel < ApplicationRecord
  has_many :lab_test_panels, dependent: :destroy
  has_many :lab_tests, through: :lab_test_panels
  has_many :accession_panels, dependent: :destroy
  has_many :accessions, through: :accession_panels
  has_many :prices, as: :priceable, dependent: :destroy

  accepts_nested_attributes_for :prices, allow_destroy: true

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :loinc, loinc: true, length: { maximum: 10 }, allow_blank: true

  scope :with_price, -> { includes(:prices).where.not(prices: { amount: nil }) }
  scope :sorted, -> { order(name: :asc) }

  auto_strip_attributes :name, :code, :procedure, :loinc

  after_commit :flush_cache
  after_create_commit -> { broadcast_prepend_later_to 'admin:panels', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_panels_path } }
  after_update_commit -> { broadcast_replace_later_to 'admin:panels' }
  after_destroy_commit -> { broadcast_remove_to 'admin:panels' }

  after_update_commit -> { broadcast_replace_later_to 'admin:panel', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_panel_path(self) }, target: :panel }
  after_destroy_commit -> { broadcast_replace_to 'admin:panel', partial: 'layouts/invalid', locals: { path: Rails.application.routes.url_helpers.admin_panels_path }, target: :panel }

  def lab_test_code_list
    LabTest.where(id: lab_test_ids).map(&:code).join(', ')
  end

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end

  def to_partial_path
    'admin/panels/panel'
  end

  def self.cached_panels
    Rails.cache.fetch([name, 'cached_panels']) do
      sorted.includes(:lab_tests).to_a
    end
  end

  private

  def flush_cache
    Rails.cache.delete([self.class.name, 'cached_panels'])
  end
end
