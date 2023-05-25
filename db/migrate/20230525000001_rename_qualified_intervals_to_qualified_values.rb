class RenameQualifiedIntervalsToQualifiedValues < ActiveRecord::Migration[7.0]
  def up
    rename_table :qualified_intervals, :qualified_values
  end

  def down
    rename_table :qualified_values, :qualified_intervals
  end
end
