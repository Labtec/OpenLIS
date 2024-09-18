# frozen_string_literal: true

class UpdateIndexPatientsSearch < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      DROP INDEX IF EXISTS index_patients_search;

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
      DROP INDEX IF EXISTS index_patients_search;

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
end
