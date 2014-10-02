class Department < ActiveRecord::Base
  # Consider caching this model
  has_many :lab_tests, dependent: :destroy
  has_many :notes, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
end
