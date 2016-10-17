namespace :doctors do
  desc 'Counter cache for doctor has many accessions'

  task accessions_counter: :environment do
    puts "Updating #{Doctor.count} doctors"

    ActiveRecord::Base.transaction do
      Doctor.reset_column_information
      Doctor.pluck(:id).each do |d|
        Doctor.reset_counters d, :accessions
        print '.'
      end
    end

    puts ' Done!'
  end
end
