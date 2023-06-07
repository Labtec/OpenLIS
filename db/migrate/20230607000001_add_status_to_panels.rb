class AddStatusToPanels < ActiveRecord::Migration[6.1]
  def up
    add_column :panels, :status, :publication_status, default: 'active'

    execute <<-SQL
      UPDATE panels SET status = 'active';
    SQL
  end

  def down
    remove_column :panels, :status
  end
end
