# frozen_string_literal: true

namespace :patients do
  desc "Change empty emails to nil"
  task nilify_email: :environment do
    puts "Setting email to nil"

    Patient.where(email: "").find_in_batches do |patients|
      patients.each do |patient|
        patient.update_columns(email: nil)
        print "."
      end
    end

    puts " Done!"
  end
end
