# frozen_string_literal: true

class Unit < ApplicationRecord
  has_many :lab_tests, dependent: :nullify

  validates :conversion_factor, numericality: true, allow_blank: true
  validates :conversion_factor, absence: true, unless: -> { si.present? }
  validates :conversion_factor, presence: true, if: -> { si.present? }
  validates :expression, presence: true, uniqueness: true, unless: -> { ucum.present? }

  default_scope { order(expression: :asc) }

  after_create_commit -> { broadcast_prepend_later_to "admin:units", partial: "layouts/refresh", locals: { path: Rails.application.routes.url_helpers.admin_units_path } }
  after_update_commit -> { broadcast_replace_later_to "admin:units" }
  after_destroy_commit -> { broadcast_remove_to "admin:units" }

  auto_strip_attributes :expression, :si, :ucum

  def to_partial_path
    "admin/units/unit"
  end
end
