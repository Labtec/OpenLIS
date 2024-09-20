# frozen_string_literal: true

module QuotesHelper
  def approved_by_name(approved_by)
    full_name = [ approved_by.prefix, approved_by.first_name, approved_by.last_name ].join(" ").squish
    if approved_by.suffix.blank?
      full_name
    else
      [ full_name, approved_by.suffix ].join(", ").squish
    end
  end

  def contact_name(patient)
    if patient
      tag.strong(full_name(patient))
    else
      tag.strong(t(".anonymous"))
    end
  end

  def ordered_by_practitioner(doctor)
    if doctor
      concat t("quotes.show.ordered_by")
      concat t("quotes.show.doctor")
      doctor.name
    else
      t("quotes.show.outpatient")
    end
  end

  def email_quote(quote, email)
    resend = quote.emailed_patient_at?
    email_quote_link = resend ? t(".emailed_quote") : t(".email_quote")
    email_quote_confirm = resend ? t(".confirm_emailed", email:) : t(".confirm_email", email:)
    button_to email_quote_link, email_quote_path(quote),
              method: :put, form: { data: { turbo_method: :put, turbo_confirm: email_quote_confirm } }
  end

  def quote_and_serial_number(quote)
    "#{t('quotes.quote.quote', serial_number: quote.serial_number)}#{t('quotes.quote.version', version_number: quote.version_number) if quote.version_number}"
  end
end
