# frozen_string_literal: true

namespace :patients do
  desc "Move mobile phones to a specific field"
  task change_phone_to_mobile: :environment do
    patients = Patient.where("phone like '6%'")
    puts "Updating #{patients.count} phones"

    ActiveRecord::Base.transaction do
      patients.each do |patient|
        patient.update!(cellular: patient.phone, phone: nil)
        print "."
      end
    end

    puts " Done!"
  end
end
