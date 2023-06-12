class AddQuoteLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :quote_line_items do |t|
      t.references :quote, type: :uuid, null: false, foreign_key: true
      t.references :item, polymorphic: true
      # TODO: Sorting?
      #t.integer :position # Line/Item number (relative position)
      t.decimal :discount_value, null: false, default: 0
      t.integer :discount_unit, null: false, default: 0
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
