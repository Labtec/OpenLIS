# frozen_string_literal: true

module AccessionsHelper
  def practitioner(doctor)
    if doctor
      concat t('.doctor')
      content_tag(:strong, doctor.name)
    else
      content_tag :strong, t('.walk_in')
    end
  end

  def email_patient_report(accession, email)
    if accession.emailed_patient_at
      link_to t('.emailed_report'), email_patient_accession_path(accession),
        data: { confirm: t('.confirm_emailed', email: email),
                disable_with: t('.sending_email') },
        method: :put
    else
      link_to t('.email_report'), email_patient_accession_path(accession),
        data: { confirm: t('.confirm_email', email: email),
                disable_with: t('.sending_email') },
        method: :put
    end
  end

  def email_doctor_report(accession, email)
    if accession.emailed_doctor_at
      link_to t('.emailed_report'), email_doctor_accession_path(accession),
        data: { confirm: t('.confirm_emailed', email: email),
                disable_with: t('.sending_email') },
        method: :put
    else
      link_to t('.email_report'), email_doctor_accession_path(accession),
        data: { confirm: t('.confirm_email', email: email),
                disable_with: t('.sending_email') },
        method: :put
    end
  end
end
