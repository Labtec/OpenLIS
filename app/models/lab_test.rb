class LabTest < ActiveRecord::Base
  # Consider caching this model
  #translates :name, :description
  #http://github.com/joshmh/globalize2/tree/master
  belongs_to :department
  belongs_to :unit
  has_many :reference_ranges
  has_many :lab_test_panels, dependent: :destroy
  has_many :panels, through: :lab_test_panels
  has_many :results, dependent: :destroy
  has_many :accessions, through: :results
  has_many :lab_test_value_option_joints, dependent: :destroy
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
    if also_allow == 'also_numeric'
      self.also_numeric = true
      self.ratio = false
      self.range = false
      self.fraction = false
    elsif also_allow == 'ratio'
      self.also_numeric = false
      self.ratio = true
      self.range = false
      self.fraction = false
    elsif also_allow == 'range'
      self.also_numeric = false
      self.ratio = false
      self.range = true
      self.fraction = false
    elsif also_allow == 'fraction'
      self.also_numeric = false
      self.ratio = false
      self.range = false
      self.fraction = true
    else
      self.also_numeric = false
      self.ratio = false
      self.range = false
      self.fraction = false
    end
  end

  def also_allow
    if also_numeric && !ratio && !range && !fraction
      :also_numeric
    elsif !also_numeric && ratio && !range && !fraction
      :ratio
    elsif !also_numeric && !ratio && range && !fraction
      :range
    elsif !also_numeric && !ratio && !range && fraction
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
