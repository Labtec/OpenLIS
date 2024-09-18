# frozen_string_literal: true

class AddInternationalSystemAndConversionFactorToUnits < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      --- Remove old constraints - DO NOT REVERT
      ALTER TABLE units ALTER COLUMN expression TYPE character varying;
      ALTER TABLE units ALTER COLUMN expression drop DEFAULT;
    SQL

    add_column :units, :si, :string
    add_column :units, :conversion_factor, :decimal
  end

  def down
    remove_column :units, :si
    remove_column :units, :conversion_factor
  end
end
