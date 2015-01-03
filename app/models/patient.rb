class Patient < ActiveRecord::Base
  GENDERS = [
    #Displayed  stored in db
    [ I18n.translate('patients.female'),  "F" ],
    [ I18n.translate('patients.male'),    "M" ],
    [ I18n.translate('patients.unknown'), "U" ]
  ]

  TYPES = [
    #Displayed  stored in db
    [ I18n.translate('patients.canine'), 1 ],
    [ I18n.translate('patients.feline'), 2 ],
    [ I18n.translate('patients.equine'), 3 ],
    [ I18n.translate('patients.other'),  0 ]
  ]

  validates_presence_of :given_name, :family_name, :birthdate
  validates_inclusion_of :gender, in: GENDERS.map {|disp, value| value}
  validate :birthdate_cant_be_in_the_future
  validates_uniqueness_of :identifier, allow_blank: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_blank: true
  validates_uniqueness_of :policy_number, allow_blank: true

  belongs_to :insurance_provider, inverse_of: :patients
  has_many :accessions, inverse_of: :patient, dependent: :destroy
  has_many :notes, as: :noticeable

  accepts_nested_attributes_for :accessions, allow_destroy: true

  scope :recent, -> { order(updated_at: :desc).limit(10) }
  scope :sorted, -> { order(family_name: :asc) }
  scope :ordered, ->(order) { order(order.flatten.first || 'created_at DESC') }

  before_save :titleize_names

  def self.search(query, page)
    sql_string = '(given_name LIKE ? OR middle_name LIKE ? OR family_name LIKE ? OR family_name2 LIKE ? OR identifier LIKE ?)'
    terms = query.to_s.split
    conditions = [([sql_string] * terms.size).join(" AND ")]
    terms.each do |term|
      conditions << Array("%#{term}%") * 5 # number of ?s in `sql_string`
    end
    self.where(conditions.flatten).page(page)
  end

  def full_name
    [given_name, middle_name, family_name, family_name2].join(' ').squeeze(' ').strip
  end

  def name_last_comma_first_mi
    last_comma_first = [family_name, given_name].join(', ')
    mi = (middle_name[0,1] + '.') unless middle_name.blank?
    [last_comma_first, mi].join(' ').strip
  end

  def age
    days_per_year = 365.25
    ((Date.today - birthdate.to_date).to_i / days_per_year).floor
  end

  def age_to_display
    age_in_days = (Date.today - birthdate.to_date).to_i
    parts = age_parts(age_in_days)
    if parts['years'] == 0
      if parts['months'] == 0
        parts['days']
      else
        parts['months']
      end
    else
      parts['years']
    end
  end

  def age_units
    age_in_days = (Date.today - birthdate.to_date).to_i
    parts = age_parts(age_in_days)
    if parts['years'] == 0
      if parts['months'] == 0
        I18n.t('patients.day')
      else
        I18n.t('patients.month')
      end
    else
      I18n.t('patients.year')
    end
  end

  def age_parts(in_days)
    parts = Hash.new
    factors = [['years', 365.25],['months', 30.4375],['days', 1]]
    factors.collect do |unit, factor|
      value, in_days = in_days.divmod(factor)
      parts[unit] = value
    end
    parts
  end

  def gender_name
    case gender
    when "F"
      I18n.translate('patients.female')
    when "M"
      I18n.translate('patients.male')
    when "U"
      I18n.translate('patients.unknown')
    else
      I18n.translate('patients.unknown')
    end
  end

  def animal_type_name
    case animal_type
    when 0
      I18n.t('patients.other')
    when 1
      I18n.t('patients.canine')
    when 2
      I18n.t('patients.feline')
    when 3
      I18n.t('patients.equine')
    end
  end

private

  def birthdate_cant_be_in_the_future
    errors.add(:birthdate, I18n.t('flash.patient.birthday_cant_be_in_the_future')) if birthdate > Date.today unless birthdate.nil?
  end

  ##
  # Must be extended to capitalize international characters (á, é ...)
  # In ruby 1.9.3 use mb_chars
  def titleize_names
    self.given_name = given_name.titleize.squeeze(' ').strip if given_name
    self.middle_name = middle_name.titleize.squeeze(' ').strip if middle_name
    self.family_name = family_name.squeeze(' ').strip if family_name
    self.family_name2 = family_name2.squeeze(' ').strip if family_name2
    self.identifier = identifier.squeeze(' ').strip if identifier
    self.phone = phone.squeeze(' ').strip if phone
    self.address = address.squeeze(' ').strip if address
  end
end
