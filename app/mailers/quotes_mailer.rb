# frozen_string_literal: true

class QuotesMailer < ApplicationMailer
  def email_quote(quote, pdf)
    @quote = quote
    attachments["#{@quote.serial_number}.pdf"] = pdf.render if pdf
    mail(to: @quote.email, subject: t('.subject', quote_number: @quote.serial_number))
  end
end
