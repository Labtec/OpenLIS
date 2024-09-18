# frozen_string_literal: true

class AddCodeColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :ucum, :string
    add_column :lab_test_values, :snomed, :string
    add_column :lab_test_values, :loinc, :string
  end
end
