class AddRemarksToLabTests < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_tests, :remarks, :text
  end
end
