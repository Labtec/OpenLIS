# frozen_string_literal: true

class AddStatusToPriceLists < ActiveRecord::Migration[7.0]
  def change
    add_column :price_lists, :status, :integer, null: false, default: 0
  end
end
