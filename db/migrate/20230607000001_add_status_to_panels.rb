# frozen_string_literal: true

class AddStatusToPanels < ActiveRecord::Migration[7.0]
  def up
    add_column :panels, :status, :publication_status, default: "active"

    execute <<-SQL.squish
      UPDATE panels SET status = 'active';
    SQL
  end

  def down
    remove_column :panels, :status
  end
end
