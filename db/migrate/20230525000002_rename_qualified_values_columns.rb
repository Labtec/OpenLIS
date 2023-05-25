class RenameQualifiedValuesColumns < ActiveRecord::Migration[7.0]
  def up
    rename_column :qualified_values, :category, :range_category
  end

  def down
    rename_column :qualified_values, :range_category, :category
  end
end
