class AddInternationalSystemAndConversionFactorToUnits < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :si, :string
    add_column :units, :conversion_factor, :decimal
  end
end
