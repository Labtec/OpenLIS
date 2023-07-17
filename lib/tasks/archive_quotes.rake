# frozen_string_literal: true

namespace :quotes do
  desc 'Archive expired quotes'

  task archive: :environment do
    puts "Archiving expired quotes"
    Quote.where('expires_at < ?', Time.current).find_in_batches do |expired_quotes|
      expired_quotes.each do |expired_quote|
        expired_quote.archived!
        print '.'
      end
      puts ' Done!'
    end

    puts "Deleting unapproved quotes"
    # status = 0 => draft
    Quote.where('created_at < ? AND status = 0', Time.current - Quote::VALIDITY_DURATION).find_in_batches do |unapproved_quotes|
      unapproved_quotes.each do |unapproved_quote|
        unapproved_quote.destroy!
        print '.'
      end
      puts ' Done!'
    end
  end
end
