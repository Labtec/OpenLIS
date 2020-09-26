# frozen_string_literal: true

namespace :patients do
  desc 'Initialize the identifier type'
  task initialize_identifier_type: :environment do
    patients = Patient.where.not(identifier: nil?)
    puts "Updating #{patients.count} patients"

    ActiveRecord::Base.transaction do
      patients.each do |patient|
        patient.update!(identifier_type: identifier_type(patient.identifier))
        print '.'
      end
    end

    puts ' Done!'
  end

  private

  def identifier_type(identifier)
    /\A\d+\z|\A\w{1,2}\d+\z/.match?(identifier) ? 2 : 1
  end
end
