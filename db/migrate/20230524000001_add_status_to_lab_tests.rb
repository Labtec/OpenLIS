class AddStatusToLabTests < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      -- https://hl7.org/fhir/valueset-publication-status.html
      CREATE TYPE publication_status AS ENUM ('draft', 'active', 'retired', 'unknown');
    SQL

    add_column :lab_tests, :status, :publication_status, default: 'active'

    execute <<-SQL
      UPDATE lab_tests SET status = 'active';
    SQL
  end

  def down
    remove_column :lab_tests, :status

    execute <<-SQL
      DROP TYPE publication_status;
    SQL
  end
end
