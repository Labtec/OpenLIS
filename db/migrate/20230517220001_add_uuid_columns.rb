class AddUUIDColumns < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    add_column :doctors, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :insurance_providers, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :patients, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
