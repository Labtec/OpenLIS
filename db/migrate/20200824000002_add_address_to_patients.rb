class AddAddressToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :address, :jsonb, default: {}
  end
end
