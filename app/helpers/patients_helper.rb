module PatientsHelper
  def avatar_for(patient)
    if patient.animal_type
      content_tag :span, class: 'avatar' do
        image_tag("avatar_#{patient.animal_type}.png")
      end
    else
      content_tag :span, class: 'avatar' do
        image_tag("avatar_#{patient.gender}.png")
      end
    end
  end

  def avatar_icon(patient)
    if patient.animal_type
      image_tag('spacer.gif', class: "avatar_#{patient.animal_type}")
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

  def options_for_types
    [
      [ I18n.translate('patients.canine'), 1 ],
      [ I18n.translate('patients.feline'), 2 ],
      [ I18n.translate('patients.equine'), 3 ],
      [ I18n.translate('patients.other'),  0 ]
    ]
  end
end
