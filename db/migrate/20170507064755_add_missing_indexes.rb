# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :lab_test_value_option_joints, :lab_test_id
    add_index :lab_test_value_option_joints, :lab_test_value_id
    add_index :notes, :department_id
  end
end
