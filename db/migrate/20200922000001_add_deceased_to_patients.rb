class AddDeceasedToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :deceased, :boolean
  end
end
