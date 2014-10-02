class PriceList < ActiveRecord::Base
  has_many :prices, :dependent => :nullify
  has_many :insurance_providers, :dependent => :nullify
  validates_uniqueness_of :name
  
  attr_accessible :name

  named_scope :grouped, :group => :name
end
