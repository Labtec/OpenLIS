class DoctorsMailer < ApplicationMailer

  def email(accession, pdf)
    @accession = accession
    attachments["resultados_#{@accession.id}.pdf"] = pdf.render if pdf
    mail(to: @accession.doctor.email,
         subject: t('.subject', full_name: full_name(@accession.patient)))
  end
end
