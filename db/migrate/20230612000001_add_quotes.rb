class AddQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes, id: :uuid do |t|
      t.bigint :serial_number, null: false, index: true, unique: true
      t.references :price_list, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :approved_by, null: true, foreign_key: { to_table: :users }
      t.datetime :expires_at
      t.datetime :approved_at
      t.references :service_request, null: true, foreign_key: { to_table: :accessions }
      t.references :patient, null: true, foreign_key: true
      t.datetime :emailed_patient_at
      t.references :doctor, null: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.decimal :shipping_and_handling, null: false, default: 0
      t.text :note

      t.timestamps
    end
  end
end
