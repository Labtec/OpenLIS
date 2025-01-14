# frozen_string_literal: true

namespace :quotes do
  desc "Create a new yearly price list"

  task new_year_price_list: :environment do
    puts "Creating new yearly price list"
    PriceList.create!(name: "MLPL#{Date.today.year}")

    puts "Duplicating current price list"
    last_price_list = PriceList.second_to_last
    current_price_list = PriceList.last
    Price.where(price_list_id: last_price_list.id).find_in_batches do |current_prices|
      current_prices.each do |price|
        new_price = price.dup
        new_price.price_list_id = current_price_list.id
        new_price.save!
        print "."
      end
    end
    puts " Done!"

    puts "Archiving old price list"
    last_price_list.archived!
    puts " Done!"
  end
end
