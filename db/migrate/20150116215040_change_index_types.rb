# frozen_string_literal: true

class ChangeIndexTypes < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL.squish
      DROP INDEX IF EXISTS index_patients_on_family_name;
      DROP INDEX IF EXISTS index_patients_on_family_name2;
      DROP INDEX IF EXISTS index_patients_on_given_name;
      DROP INDEX IF EXISTS index_patients_on_identifier;
      DROP INDEX IF EXISTS index_patients_on_middle_name;

      CREATE OR REPLACE FUNCTION my_unaccent(varchar)
        RETURNS varchar
        AS $$ select unaccent('unaccent', $1::text); $$
        LANGUAGE 'sql'
        IMMUTABLE;

      CREATE INDEX index_patients_on_lower_family_name
        ON patients (LOWER(my_unaccent(family_name)));

      CREATE INDEX index_patients_search
        ON patients
        USING GIN((
          to_tsvector('simple', my_unaccent(coalesce("patients"."identifier"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."family_name"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."family_name2"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."given_name"::text, ''))) ||
          to_tsvector('simple', my_unaccent(coalesce("patients"."middle_name"::text, '')))
        ));
    SQL
  end

  def down
    execute <<-SQL.squish
      DROP INDEX IF EXISTS index_patients_on_lower_family_name;
      DROP INDEX IF EXISTS index_patients_search;
      DROP FUNCTION IF EXISTS my_unaccent(varchar) CASCADE;
    SQL

    add_index :patients, [ :family_name ], name: "index_patients_on_family_name"
    add_index :patients, [ :family_name2 ], name: "index_patients_on_family_name2"
    add_index :patients, [ :given_name ], name: "index_patients_on_given_name"
    add_index :patients, [ :identifier ], name: "index_patients_on_identifier"
    add_index :patients, [ :middle_name ], name: "index_patients_on_middle_name"
  end
end
