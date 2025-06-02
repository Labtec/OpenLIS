class AddProcedureUnits < ActiveRecord::Migration[7.2]
  def change
    add_column :lab_tests, :procedure_quantity, :integer
    add_column :panels, :procedure_quantity, :integer
  end
end
