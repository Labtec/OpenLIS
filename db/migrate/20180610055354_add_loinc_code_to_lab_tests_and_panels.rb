class AddLOINCCodeToLabTestsAndPanels < ActiveRecord::Migration[5.2]
  def change
    add_column :lab_tests, :loinc, :string
    add_column :panels, :loinc, :string

    add_index :lab_tests, :loinc
    add_index :panels, :loinc
  end
end
