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
  end
end
