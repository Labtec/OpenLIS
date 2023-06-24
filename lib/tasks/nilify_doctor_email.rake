# frozen_string_literal: true

namespace :doctors do
  desc 'Change empty emails to nil'
  task nilify_email: :environment do
    puts 'Setting email to nil'

    Doctor.where(email: '').find_in_batches do |doctors|
      doctors.each do |doctor|
        doctor.update_columns(email: nil)
        print '.'
      end
    end

    puts ' Done!'
  end
end
