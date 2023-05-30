# frozen_string_literal: true

module PatientsHelper
  def animal_species_name(species)
    case species
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

  def avatar_icon(patient)
    tag.svg(class: 'avatar') do
      case patient.animal_type
      when 0
        tag.use('xlink:href' => image_path('avatars.svg#U'))
      when 1
        tag.use('xlink:href' => image_path('avatars.svg#canine'))
      when 2
        tag.use('xlink:href' => image_path('avatars.svg#feline'))
      when 3
        tag.use('xlink:href' => image_path('avatars.svg#equine'))
      else
        tag.use('xlink:href' => image_path("avatars.svg##{patient.gender}"))
      end
    end
  end

  # Returns the full name of a patient.
  def full_name(patient)
    if patient.family_name.blank? && patient.animal_type.present?
      return [patient.given_name,
              patient.middle_name,
              "(#{animal_species_name(patient.animal_type)})"].join(' ').squish
    end

    [patient.given_name,
     patient.middle_name,
     patient.family_name,
     patient.family_name2,
     patient.partner_name].join(' ').squish
  end

  def name_last_comma_first_mi(patient)
    family_name = (patient.partner_name || patient.family_name)
    family_name[0] = family_name[0].mb_chars.upcase
    last_comma_first = [family_name, patient.given_name].join(', ')
    mi = "#{patient.middle_name[0, 1]}." if patient.middle_name.present?
    ActiveSupport::Inflector.transliterate([last_comma_first, mi].join(' ').squish)
  end

  # XXX: Unused helper.
  # Returns the official full name of a patient without accents.
  # Historically, names were registered using typewriters, and in capital
  # letters, which did not have accents, except for the letter "Ñ".
  def es_official_name(patient)
    return if patient.family_name.blank? || patient.animal_type.present?

    full_name = [patient.given_name,
                 patient.middle_name,
                 patient.family_name,
                 patient.family_name2].join(' ').squish

    ActiveSupport::Inflector.transliterate(full_name).upcase
  end

  def options_for_gender
    [
      [t('patients.female'),  'F'],
      [t('patients.male'),    'M'],
      [t('patients.other'),   'O'],
      [t('patients.unknown'), 'U']
    ]
  end

  def options_for_animal_species
    [
      [t('patients.canine'), 1],
      [t('patients.feline'), 2],
      [t('patients.equine'), 3],
      [t('patients.other'),  0]
    ]
  end

  def options_for_identifier_type
    [
      [t('patients.form.cedula'), 1],
      [t('patients.form.passport'), 2]
    ]
  end

  # Returns a human-readable age string.
  def display_pediatric_age(age)
    return t('patients.unknown_age') unless age

    pediatric_age = age.parts

    years = t('patients.year', count: pediatric_age[:years]) if pediatric_age[:years]
    months = t('patients.month', count: pediatric_age[:months]) if pediatric_age[:months]
    weeks = t('patients.week', count: pediatric_age[:weeks]) if pediatric_age[:weeks]
    days = t('patients.day', count: pediatric_age[:days]) if pediatric_age[:days]

    [years, months, weeks, days].compact.join(' ')
  end

  # Returns the gender of a patient spelled out
  def gender(gender)
    case gender
    when 'F', 'female'
      t('patients.female')
    when 'M', 'male'
      t('patients.male')
    when 'O', 'other'
      t('patients.other')
    else
      t('patients.unknown')
    end
  end

  # Returns a phone number formatted
  def format_phone_number(phone)
    parsed_phone = Phonelib.parse(phone)

    if parsed_phone.country == Phonelib.default_country
      parsed_phone.local_number
    else
      parsed_phone.full_international
    end
  end

  # Returns a phone number E.164-formatted
  def format_phone_number_e164(phone)
    Phonelib.parse(phone).e164
  end

  # Returns a full phone number in international format,
  # omitting any zeroes, brackets, dashes or + sign
  def whatsapp_format(phone)
    Phonelib.parse(phone).international(false).tr('+', '')
  end

  # Returns a click-to-chat WhatsApp url
  def whatsapp_click_to_chat_url(phone)
    "https://api.whatsapp.com/send?phone=#{whatsapp_format(phone)}&text&source&data&&lang=#{current_user.language}"
  end
end
