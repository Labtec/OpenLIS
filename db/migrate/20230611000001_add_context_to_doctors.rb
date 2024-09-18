# frozen_string_literal: true

class AddContextToDoctors < ActiveRecord::Migration[7.0]
  def change
    remove_column :doctors, :gender, :string # never used
    add_column :doctors, :gender, :enum, enum_type: :administrative_gender

    # While we migrate to a person model
    add_column :doctors, :organization, :boolean, default: false
  end
end
