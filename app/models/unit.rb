class Unit < ActiveRecord::Base
  # Consider caching this model
  #translates :name
  has_many :lab_tests
  default_scope :order => "name"
  attr_accessible :name
end
