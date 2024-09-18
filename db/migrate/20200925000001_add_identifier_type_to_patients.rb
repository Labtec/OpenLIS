class AddIdentifierTypeToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :identifier_type, :integer
  end
end
