# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/results_mailer
class ResultsMailerPreview < ActionMailer::Preview
  def email_patient
    accession = Accession.first
    pdf = nil
    ResultsMailer.email_patient(accession, pdf)
  end

  def email_doctor
    accession = Accession.first
    pdf = nil
    ResultsMailer.email_doctor(accession, pdf)
  end
end
