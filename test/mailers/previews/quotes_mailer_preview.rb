# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/quotes_mailer
class QuotesMailerPreview < ActionMailer::Preview
  def email_quote
    quote = Quote.first
    pdf = nil
    QuotesMailer.email_quote(quote, pdf)
  end
end
