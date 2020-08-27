class RemoveAddressFromPatients < ActiveRecord::Migration[6.0]
  def change
    remove_column :patients, :address, :text
  end
end
