class Panel < ActiveRecord::Base
  # Consider caching this model
  has_many :lab_test_panels
  has_many :lab_tests, :through => :lab_test_panels
  has_many :accession_panels
  has_many :accessions, :through => :accession_panels
  has_many :prices, :as => :priceable, :dependent => :destroy
  accepts_nested_attributes_for :prices, :allow_destroy => true

  validates_presence_of :code
  validates_uniqueness_of :code

  named_scope :with_price, :include => :prices, :conditions => ["prices.amount IS NOT NULL"]
  named_scope :sorted, :order => :name

  def lab_test_code_list
    list = []
    lab_tests.each do |lab_test|
      list << lab_test.code
    end
    list.join(', ')
  end

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end
end
