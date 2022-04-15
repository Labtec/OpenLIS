# frozen_string_literal: true

class InsuranceProvider < ApplicationRecord
  belongs_to :price_list

  has_many :claims, dependent: :destroy
  has_many :patients, dependent: :nullify
  has_many :accessions, through: :patients
  has_many :prices, through: :price_list

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name

  after_create_commit -> { broadcast_prepend_later_to 'admin:insurance_providers', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_insurance_providers_path } }
  after_update_commit -> { broadcast_replace_later_to 'admin:insurance_providers' }
  after_destroy_commit -> { broadcast_remove_to 'admin:insurance_providers' }

  after_update_commit -> { broadcast_replace_later_to 'admin:insurance_provider', partial: 'layouts/refresh', locals: { path: Rails.application.routes.url_helpers.admin_insurance_provider_path(self) }, target: :insurance_provider }
  after_destroy_commit -> { broadcast_replace_to 'admin:insurance_provider', partial: 'layouts/invalid', locals: { path: Rails.application.routes.url_helpers.admin_insurance_providers_path }, target: :insurance_provider }

  def to_partial_path
    'admin/insurance_providers/insurance_provider'
  end
end
