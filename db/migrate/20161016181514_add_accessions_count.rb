# frozen_string_literal: true

class AddAccessionsCount < ActiveRecord::Migration[5.0]
  def change
    add_column :doctors, :accessions_count, :integer, default: 0
  end
end
