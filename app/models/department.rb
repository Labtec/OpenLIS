# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :lab_tests, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name
end
