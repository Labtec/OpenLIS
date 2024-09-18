# frozen_string_literal: true

class AddSignatureToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :signature, :text
    add_column :users, :descender, :boolean
  end
end
