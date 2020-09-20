# frozen_string_literal: true

class Unit < ApplicationRecord
  has_many :lab_tests, dependent: :nullify

  validates :name, presence: true, uniqueness: true, unless: -> { ucum.present? }

  default_scope { order(name: :asc) }

  auto_strip_attributes :name, :ucum

  def name_display
    return name if name.present?

    ucum
  end
end
