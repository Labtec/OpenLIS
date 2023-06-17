# frozen_string_literal: true

module PractitionersHelper
  def organization_or_practitioner(doctor)
    return I18n.t('practitioners.outpatient') unless doctor

    if doctor.organization
      doctor.name
    else
      "#{practitioner_gender(doctor)} #{doctor.name}"
    end
  end

  def practitioner_gender(doctor)
    return unless doctor
    return if doctor.organization

    case doctor.gender
    when 'male'
      I18n.t('practitioners.male_dr_prefix')
    when 'female'
      I18n.t('practitioners.female_dr_prefix')
    else
      I18n.t('practitioners.unknown_dr_prefix')
    end
  end
end
