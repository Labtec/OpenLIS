class CreateWebauthnCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :webauthn_credentials do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.string :public_key, null: false
      t.string :nickname, null: false
      t.bigint :sign_count, null: false, default: 0

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
