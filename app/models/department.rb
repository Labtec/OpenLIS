class Department < ActiveRecord::Base
  # Consider caching this model
  has_many :lab_tests, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :name,
    presence:   true,
    uniqueness: true
end
