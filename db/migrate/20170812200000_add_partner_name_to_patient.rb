class AddPartnerNameToPatient < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :partner_name, :string
    add_index :patients, :partner_name
  end
end
