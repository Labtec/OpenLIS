class AddEmailTimestampToAccessions < ActiveRecord::Migration[5.2]
  def change
    add_column :accessions, :emailed_doctor_at, :datetime
    add_column :accessions, :emailed_patient_at, :datetime
  end
end
