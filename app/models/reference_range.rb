class ReferenceRange < ActiveRecord::Base
  # Consider caching this model

  GENDERS = [
    #Displayed  stored in db
    [ "Both",     "*" ],
    [ "Female",   "F" ],
    [ "Male",     "M" ],
    [ "Unknown",  "U" ]
  ]

  AGE_UNITS = [
    #Displayed  stored in db
    [ "Years",    "Y" ],
    [ "Months",   "M" ],
    [ "Weeks",    "W" ],
    [ "Days",     "D" ]
  ]

  ANIMAL_TYPES = [
    #Displayed  stored in db
    [ "None",   nil ],
    [ "Dog",   1 ],
    [ "Cat",   2 ],
    [ "Horse", 3 ]
  ]

  belongs_to :lab_test

  scope :for_its_gender, lambda { |gender| { :conditions => { :gender => [gender, "*"] } } }
  scope :for_its_type, lambda { |type| { :conditions => { :animal_type => type } } }
  scope :for_its_age_in_units, lambda { |age_days, age_weeks, age_months, age_years| { :conditions => ["(min_age <= ? AND max_age > ? AND age_unit = 'D') OR (min_age <= ? AND max_age IS NULL AND age_unit = 'D') OR (min_age IS NULL AND max_age > ? AND age_unit = 'D') OR (min_age IS NULL AND max_age IS NULL) OR (min_age <= ? AND max_age > ? AND age_unit = 'W') OR (min_age <= ? AND max_age IS NULL AND age_unit = 'W') OR (min_age IS NULL AND max_age > ? AND age_unit = 'W') OR (min_age IS NULL AND max_age IS NULL) OR (min_age <= ? AND max_age > ? AND age_unit = 'M') OR (min_age <= ? AND max_age IS NULL AND age_unit = 'M') OR (min_age IS NULL AND max_age > ? AND age_unit = 'M') OR (min_age IS NULL AND max_age IS NULL) OR (min_age <= ? AND max_age > ? AND age_unit = 'Y') OR (min_age <= ? AND max_age IS NULL AND age_unit = 'Y') OR (min_age IS NULL AND max_age > ? AND age_unit = 'Y') OR (min_age IS NULL AND max_age IS NULL)", age_days, age_days, age_days, age_days, age_weeks, age_weeks, age_weeks, age_weeks, age_months, age_months, age_months, age_months, age_years, age_years, age_years, age_years] } }

  validates_inclusion_of :gender, :in => GENDERS.map {|disp, value| value}

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
    else
      ""
    end
  end
end
