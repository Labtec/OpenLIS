class Department < ApplicationRecord
  has_many :lab_tests, inverse_of: :department, dependent: :destroy
  has_many :notes, inverse_of: :department, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  auto_strip_attributes :name
end
