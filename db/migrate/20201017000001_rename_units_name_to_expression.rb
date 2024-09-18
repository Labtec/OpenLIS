# frozen_string_literal: true

class RenameUnitsNameToExpression < ActiveRecord::Migration[6.0]
  def change
    rename_column :units, :name, :expression
  end
end
