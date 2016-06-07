class Unit < ApplicationRecord
  has_many :lab_tests, inverse_of: :unit

  validates :name, presence: true, uniqueness: true

  default_scope { order(name: :asc) }

  auto_strip_attributes :name
end
