class AddEmailToDoctors < ActiveRecord::Migration[5.0]
  def change
    add_column :doctors, :email, :string
  end
end
