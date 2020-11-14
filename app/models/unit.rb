# frozen_string_literal: true

class Unit < ApplicationRecord
  has_many :lab_tests, dependent: :nullify

  validates :conversion_factor, numericality: true, allow_blank: true
  validates :conversion_factor, absence: true, unless: -> { si.present? }
  validates :conversion_factor, presence: true, if: -> { si.present? }
  validates :expression, presence: true, uniqueness: true, unless: -> { ucum.present? }

  default_scope { order(expression: :asc) }

  auto_strip_attributes :expression, :si, :ucum
end
