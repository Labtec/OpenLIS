# frozen_string_literal: true

class RenameReferenceRangesToQualifiedIntervals < ActiveRecord::Migration[6.0]
  def up
    rename_table :reference_ranges, :qualified_intervals
  end

  def down
    rename_table :qualified_intervals, :reference_ranges
  end
end
