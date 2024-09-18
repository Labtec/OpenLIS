# frozen_string_literal: true

class RenameResultsToObservations < ActiveRecord::Migration[6.0]
  def up
    rename_table :results, :observations
  end

  def down
    rename_table :observations, :results
  end
end
