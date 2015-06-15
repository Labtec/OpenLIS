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
    mi = (patient.middle_name[0,1] + '.') unless patient.middle_name.blank?
    [last_comma_first, mi].join(' ').squish
  end

  def options_for_gender
    [
      [ I18n.translate('patients.female'),  'F' ],
      [ I18n.translate('patients.male'),    'M' ],
      [ I18n.translate('patients.unknown'), 'U' ]
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
end
