# frozen_string_literal: true

namespace :patients do
  desc "Archive patients older than 120 years"

  task archive: :environment do
    puts "Archiving patients table"
    ActiveRecord::Base.transaction do
      Patient.where("birthdate < ?", Time.now - 120.years).find_in_batches do |patients|
        patients.each do |patient|
          patient.update_columns(deceased: true)
          print "."
        end
      end

      puts " Done!"
    end
  end
end
