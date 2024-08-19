# frozen_string_literal: true

namespace :doctors do
  desc "Remove Doctors not associated with any patient"

  task purge: :environment do
    puts "Purging doctors table"
    ActiveRecord::Base.transaction do
      Doctor.all.each do |doctor|
        unless doctor.accessions_count? || doctor.quotes_count?
          doctor.destroy!
          print "."
        end
      end

      puts " Done!"
      Rails.cache.delete("doctors")
    end
  end
end
