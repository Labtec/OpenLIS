class AddPatientPreparationToSpecimenDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :lab_tests, :fasting_status_duration, :interval
    add_column :lab_tests, :patient_preparation, :text

    add_column :panels, :fasting_status_duration, :interval
    add_column :panels, :patient_preparation, :text
  end
end
