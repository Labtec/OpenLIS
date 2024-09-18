class AddNumericToLabTestValues < ActiveRecord::Migration[5.2]
  def change
    add_column :lab_test_values, :numeric, :boolean
  end
end
