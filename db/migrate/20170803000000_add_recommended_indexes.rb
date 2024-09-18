# frozen_string_literal: true

class AddRecommendedIndexes < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def change
    add_index :accessions, [ :reported_at, :drawn_at ], algorithm: :concurrently
    add_index :claims, :claimed_at, algorithm: :concurrently
    add_index :patients, :policy_number, algorithm: :concurrently
    add_index :patients, :updated_at, algorithm: :concurrently
  end
end
