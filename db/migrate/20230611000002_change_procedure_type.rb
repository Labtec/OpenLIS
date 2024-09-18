# frozen_string_literal: true

class ChangeProcedureType < ActiveRecord::Migration[7.0]
  def change
    change_column :lab_tests, :procedure, :string
    change_column :panels, :procedure, :string
  end
end
