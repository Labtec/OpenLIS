class ResultsMailer < ApplicationMailer

  def email(accession, pdf)
    @accession = accession
    attachments["resultados_#{@accession.id}.pdf"] = pdf.render if pdf
    mail(to: @accession.patient.email, subject: t('.subject'))
  end
end
