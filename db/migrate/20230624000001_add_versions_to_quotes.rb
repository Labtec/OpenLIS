class AddVersionsToQuotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :quotes, :parent_quote, type: :uuid, null: true, foreign_key: { to_table: :quotes }
    add_column :quotes, :version_number, :integer
  end
end
