# frozen_string_literal: true

class AddCodesToDepartments < ActiveRecord::Migration[6.0]
  def change
    add_column :departments, :code, :string
    add_column :departments, :loinc_class, :string
  end
end
