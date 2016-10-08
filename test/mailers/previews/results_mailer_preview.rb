# Preview all emails at http://localhost:3000/rails/mailers/results_mailer
class ResultsMailerPreview < ActionMailer::Preview
  def email
    accession = Accession.first
    pdf = nil
    ResultsMailer.email(accession, pdf)
  end
end
