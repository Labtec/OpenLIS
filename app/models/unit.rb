class Unit < ActiveRecord::Base
  # Consider caching this model
  #translates :name
  has_many :lab_tests, inverse_of: :unit

  default_scope { order(name: :asc) }
end
