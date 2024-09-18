# frozen_string_literal: true

class AddCellularToPatients < ActiveRecord::Migration[5.2]
  def change
    add_column :patients, :cellular, :string, limit: 32
  end
end
