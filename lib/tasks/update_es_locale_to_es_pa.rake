# frozen_string_literal: true

namespace :users do
  desc "Update users with an 'es' locale to an 'es-PA' locale"
  task update_es_locale_to_es_pa: :environment do
    users = User.where(language: "es")
    puts "Updating #{users.count} users"

    ActiveRecord::Base.transaction do
      users.each do |user|
        user.update!(language: "es-PA")
        print "."
      end
    end

    puts " Done!"
  end
end
