# frozen_string_literal: true

class QuotesMailer < ApplicationMailer
  def email_quote(quote, pdf)
    @quote = quote
    attachments["#{serial_number}.pdf"] = pdf.render if pdf
    mail(to: @quote.email, subject: t('.subject', quote_number: serial_number))
  end

  private

  def serial_number
    if @quote.version_number
      "#{@quote.serial_number}-#{@quote.version_number}"
    else
      @quote.serial_number.to_s
    end
  end
end
