class AddQuotesCountToDoctors < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :quotes_count, :integer, default: 0
  end
end
