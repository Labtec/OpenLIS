module PatientsHelper
  def animal_type_name(type)
    case type
    when 0
      t('patients.other')
    when 1
      t('patients.canine')
    when 2
      t('patients.feline')
    when 3
      t('patients.equine')
    else
      ''
    end
  end

  def avatar_for(patient)
    content_tag :span, class: 'avatar' do
      case patient.animal_type
      when 0
        image_tag('avatar_other.png')
      when 1
        image_tag('avatar_canine.png')
      when 2
        image_tag('avatar_feline.png')
      when 3
        image_tag('avatar_equine.png')
      else
        image_tag("avatar_#{patient.gender}.png")
      end
    end
  end

  def avatar_icon(patient)
    case patient.animal_type
    when 0
      image_tag('spacer.gif', class: 'avatar_other')
    when 1
      image_tag('spacer.gif', class: 'avatar_canine')
    when 2
      image_tag('spacer.gif', class: 'avatar_feline')
    when 3
      image_tag('spacer.gif', class: 'avatar_equine')
    else
      image_tag('spacer.gif', class: "avatar_#{patient.gender}")
    end
  end

  # Returns the full name of a patient.
  def full_name(patient)
    [patient.given_name,
     patient.middle_name,
     patient.family_name,
     patient.family_name2].join(' ').squish
  end

  def name_last_comma_first_mi(patient)
    family_name = patient.family_name
    family_name[0] = family_name[0].mb_chars.upcase
    last_comma_first = [family_name, patient.given_name].join(', ')
    mi = (patient.middle_name[0, 1] + '.') unless patient.middle_name.blank?
    [last_comma_first, mi].join(' ').squish
  end

  def options_for_gender
    [
      [t('patients.female'),  'F'],
      [t('patients.male'),    'M'],
      [t('patients.unknown'), 'U']
    ]
  end

  def options_for_animal_types
    [
      [ t('patients.canine'), 1 ],
      [ t('patients.feline'), 2 ],
      [ t('patients.equine'), 3 ],
      [ t('patients.other'),  0 ]
    ]
  end

  # Returns a hash with the age of a patient at any given time.
  # If no time is given, +Time.now+ is used.
  #
  # Units to be used for displaying a patient's age:
  #
  #     | Age         | Lower Unit | Higher Unit |
  #     | ----------- | ---------- | ----------- |
  #     | < 2 hours   | Minutes    | Minutes     |
  #     | < 2 days    | Hours      | Hours       |
  #     | < 4 weeks   | Days       | Days        |
  #     | < 1 year    | Weeks      | Days        |
  #     | < 2 years   | Months     | Days        |
  #     | < 18 years  | Years      | Months      |
  #     | >= 18 years | Years      | Years       |
  def age_hash(birth_date, service_date = Time.now)
    patient_age = AgeCalculator.new(birth_date, service_date)
    age_in = patient_age.time_units
    remainder = patient_age.remainders

    case
    when age_in[:weeks] < 4 # < 4 weeks
      { days: age_in[:days] }
    when age_in[:years] < 1 # < 1 year
      { weeks: age_in[:weeks], days: remainder[:weeks] }.compact
    when age_in[:years] < 2 # < 2 years
      { months: age_in[:months], days: remainder[:months] }.compact
    when age_in[:years] < 18 # < 18 years
      { years: age_in[:years], months: remainder[:years] }.compact
    else # >= 18 years
      { years: age_in[:years] }
    end
  end

  # Returns a human-readable age string.
  def age(birth_date, service_date = Time.now)
    age = age_hash(birth_date, service_date)

    years = t('patients.year', count: age[:years]) if age[:years]
    months = t('patients.month', count: age[:months]) if age[:months]
    weeks = t('patients.week', count: age[:weeks]) if age[:weeks]
    days = t('patients.day', count: age[:days]) if age[:days]

    [years, months, weeks, days].compact.join(' ')
  end

  # Returns the gender of a patient according to the HL7 standard.
  def gender_hl7(gender)
    case gender
    when 'M'
      'M'
    when 'F'
      'F'
    when 'U'
      'UN'
    else
      'UNK'
    end
  end

  # Returns the gender of a patient spelled out
  def gender(gender)
    case gender
    when 'F'
      t('patients.female')
    when 'M'
      t('patients.male')
    when 'U'
      t('patients.unknown')
    else
      t('patients.unknown')
    end
  end
end
