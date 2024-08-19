class DropUnusedNullIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :observations, name: :index_observations_on_lab_test_value_id, column: :lab_test_value_id
    remove_index :accessions, name: :index_accessions_on_reported_at_and_drawn_at, column: [ :reported_at, :drawn_at ]
  end

  def down
    remove_index :patients, name: :index_patients_search
  end

  def up
    execute <<-SQL
      CREATE INDEX index_patients_search
        ON patients
        USING GIN((
          to_tsvector('simple', my_unaccent(coalesce("patients"."identifier"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."family_name"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."family_name2"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."partner_name"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."given_name"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."middle_name"::text, '')))
        ));
    SQL
  end
end
