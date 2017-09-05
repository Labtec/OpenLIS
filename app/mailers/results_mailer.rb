# frozen_string_literal: true

class ResultsMailer < ApplicationMailer
  def email_doctor(accession, pdf)
    @accession = accession
    subject = @accession.reported_at ? '.subject' : '.subject_preliminary'
    attachments["resultados_#{@accession.id}.pdf"] = pdf.render if pdf
    mail(to: @accession.doctor.email,
         subject: t(subject, full_name: full_name(@accession.patient)))
  end

  def email_patient(accession, pdf)
    @accession = accession
    subject = @accession.reported_at ? '.subject' : '.subject_preliminary'
    attachments["resultados_#{@accession.id}.pdf"] = pdf.render if pdf
    mail(to: @accession.patient.email,
         subject: t(subject))
  end
end
