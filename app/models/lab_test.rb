class LabTest < ActiveRecord::Base
  # Consider caching this model
  #translates :name, :description
  #http://github.com/joshmh/globalize2/tree/master
  belongs_to :department, inverse_of: :lab_tests
  belongs_to :unit, inverse_of: :lab_tests
  has_many :reference_ranges, inverse_of: :lab_test
  has_many :lab_test_panels, inverse_of: :lab_test, dependent: :destroy
  has_many :panels, through: :lab_test_panels
  has_many :results, inverse_of: :lab_test, dependent: :destroy
  has_many :accessions, through: :results
  has_many :lab_test_value_option_joints, inverse_of: :lab_test, dependent: :destroy
  has_many :lab_test_values, through: :lab_test_value_option_joints
  has_many :prices, as: :priceable, dependent: :destroy

  accepts_nested_attributes_for :prices, allow_destroy: true

  validates_presence_of :code
  validates_uniqueness_of :code

  acts_as_list scope: :department

  scope :sorted, -> { order(name: :asc) }
  scope :with_price, -> { includes(:prices).where.not(prices: { amount: nil }) }
  scope :with_code, ->(code) { where(code: code) }

  default_scope { order(position: :asc) }

  def also_allow=(also_allow)
    case also_allow
    when 'also_numeric'
      self.also_numeric = true
      self.ratio        = false
      self.range        = false
      self.fraction     = false
    when 'ratio'
      self.also_numeric = false
      self.ratio        = true
      self.range        = false
      self.fraction     = false
    when 'range'
      self.also_numeric = false
      self.ratio        = false
      self.range        = true
      self.fraction     = false
    when 'fraction'
      self.also_numeric = false
      self.ratio        = false
      self.range        = false
      self.fraction     = true
    else
      self.also_numeric = false
      self.ratio        = false
      self.range        = false
      self.fraction     = false
    end
  end

  def also_allow
    case
    when also_numeric? && !ratio? && !range? && !fraction?
      :also_numeric
    when !also_numeric? && ratio? && !range? && !fraction?
      :ratio
    when !also_numeric? && !ratio? && range? && !fraction?
      :range
    when !also_numeric? && !ratio? && !range? && fraction?
      :fraction
    else
      :none
    end
  end

  def department_name
    department.name
  end

  def name_with_description
    description.present? ? "#{name} (#{description})" : name
  end
end
