class RedefineMyUnaccentFunction < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      DROP INDEX IF EXISTS index_patients_on_lower_family_name;
      DROP INDEX IF EXISTS index_patients_search;
      DROP FUNCTION IF EXISTS my_unaccent(varchar) CASCADE;

      CREATE OR REPLACE FUNCTION my_unaccent(text)
        RETURNS text
        AS $func$ SELECT public.unaccent('public.unaccent', $1) $func$
        LANGUAGE SQL
        IMMUTABLE;

      CREATE INDEX index_patients_on_lower_family_name
        ON patients (LOWER(my_unaccent(family_name)));

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

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS index_patients_on_lower_family_name;
      DROP INDEX IF EXISTS index_patients_search;
      DROP FUNCTION IF EXISTS my_unaccent(text) CASCADE;

      CREATE OR REPLACE FUNCTION my_unaccent(varchar)
        RETURNS varchar
        AS $$ SELECT unaccent('unaccent', $1::text); $$
        LANGUAGE SQL
        IMMUTABLE;

      CREATE INDEX index_patients_on_lower_family_name
        ON patients (LOWER(my_unaccent(family_name)));

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
