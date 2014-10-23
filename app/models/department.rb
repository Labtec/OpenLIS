class Department < ActiveRecord::Base
  # Consider caching this model
  has_many :lab_tests, inverse_of: :department, dependent: :destroy
  has_many :notes, inverse_of: :department, dependent: :destroy

  validates :name,
    presence:   true,
    uniqueness: true
end
