# frozen_string_literal: true

class AddColumnsToQualifiedIntervals < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER DATABASE "#{connection.current_database}" SET intervalstyle = 'iso_8601';

      --- http://hl7.org/fhir/administrative-gender
      CREATE TYPE administrative_gender AS ENUM ('male', 'female', 'other', 'unknown');

      --- http://hl7.org/fhir/observation-range-category
      CREATE TYPE observation_range_category AS ENUM ('reference', 'critical', 'absolute');

      --- Remove old constraints - DO NOT REVERT
      ALTER TABLE qualified_intervals ALTER COLUMN description TYPE character varying;
      ALTER TABLE qualified_intervals ALTER COLUMN description drop DEFAULT;

      --- Remove old constraints - DO NOT REVERT
      ALTER TABLE qualified_intervals ALTER COLUMN min TYPE numeric;
      ALTER TABLE qualified_intervals ALTER COLUMN min drop DEFAULT;

      --- Remove old constraints - DO NOT REVERT
      ALTER TABLE qualified_intervals ALTER COLUMN max TYPE numeric;
      ALTER TABLE qualified_intervals ALTER COLUMN max drop DEFAULT;
    SQL

    # To be removed once the migration is complete
    rename_column :qualified_intervals, :gender, :old_gender
    rename_column :qualified_intervals, :min_age, :old_min_age
    rename_column :qualified_intervals, :max_age, :old_max_age
    rename_column :qualified_intervals, :age_unit, :old_age_unit

    # Model from ObservationDefinition.qualifiedInterval
    add_column :qualified_intervals, :category, :observation_range_category
    rename_column :qualified_intervals, :min, :range_low_value
    rename_column :qualified_intervals, :max, :range_high_value
    add_column :qualified_intervals, :context, :string
    add_reference :qualified_intervals, :interpretation, foreign_key: { to_table: "lab_test_values" }
    add_column :qualified_intervals, :gender, :administrative_gender
    add_column :qualified_intervals, :age_low, :string # :interval has no WEEK?
    add_column :qualified_intervals, :age_high, :string # :interval has no WEEK?
    add_column :qualified_intervals, :gestational_age_low, :string # :interval has no WEEK?
    add_column :qualified_intervals, :gestational_age_high, :string # :interval has no WEEK?
    rename_column :qualified_intervals, :description, :condition
    add_column :qualified_intervals, :rank, :integer

    execute <<-SQL.squish
      UPDATE qualified_intervals SET category = 'reference';

      UPDATE qualified_intervals
      SET rank = mapping.new_rank
      FROM (
        SELECT
          id,
          ROW_NUMBER() OVER (
            PARTITION BY lab_test_id
            ORDER BY updated_at
          ) as new_rank
        FROM qualified_intervals
      ) AS mapping
      WHERE qualified_intervals.id = mapping.id;
    SQL

    map_old_gender_to_gender
    map_old_age_values_to_age_values
    map_conditions
    Rails.logger.debug "Done!"
  end

  def down
    remove_column :qualified_intervals, :gender
    rename_column :qualified_intervals, :old_gender, :gender
    rename_column :qualified_intervals, :old_min_age, :min_age
    rename_column :qualified_intervals, :old_max_age, :max_age
    rename_column :qualified_intervals, :old_age_unit, :age_unit
    remove_column :qualified_intervals, :category
    rename_column :qualified_intervals, :range_low_value, :min
    rename_column :qualified_intervals, :range_high_value, :max
    remove_column :qualified_intervals, :context
    remove_reference :qualified_intervals, :interpretation
    remove_column :qualified_intervals, :age_low
    remove_column :qualified_intervals, :age_high
    remove_column :qualified_intervals, :gestational_age_low
    remove_column :qualified_intervals, :gestational_age_high
    rename_column :qualified_intervals, :condition, :description
    remove_column :qualified_intervals, :rank

    execute <<-SQL.squish
      DROP TYPE administrative_gender;
      DROP TYPE observation_range_category;
      ALTER DATABASE "#{connection.current_database}" SET intervalstyle = 'postgres';
    SQL
  end

  private

  def map_old_gender_to_gender
    Rails.logger.debug "Mapping old gender codes"

    ActiveRecord::Base.transaction do
      QualifiedInterval.find_each do |qi|
        case qi.old_gender
        when "M"
          qi.update(gender: "male")
        when "F"
          qi.update(gender: "female")
        end
        Rails.logger.debug "."
      end
    end

    Rails.logger.debug ""
  end

  def map_old_age_values_to_age_values
    Rails.logger.debug "Mapping old age values"

    ActiveRecord::Base.transaction do
      QualifiedInterval.find_each do |qi|
        qi.update(age_low: "P#{qi.old_min_age}#{qi.old_age_unit}") unless qi.old_min_age.nil? || qi.old_min_age.zero?
        qi.update(age_high: "P#{qi.old_max_age}#{qi.old_age_unit}") unless qi.old_max_age.nil? || qi.old_max_age.zero?
        Rails.logger.debug "."
      end
    end

    Rails.logger.debug ""
  end

  def map_conditions
    Rails.logger.debug "Mapping conditions"

    ActiveRecord::Base.transaction do
      QualifiedInterval.find_each do |qi|
        case qi.condition
        when "1ª mitad del ciclo"
          qi.update(context: "follicular")
        when "Pico ovulatorio"
          qi.update(context: "midcycle")
        when "2ª mitad del ciclo"
          qi.update(context: "luteal")
        when "Menopausia"
          qi.update(context: "postmenopausal")
        when "Terapéutico"
          qi.update(context: "therapeutic")
        when "0–1 semana"
          qi.update(gestational_age_high: 1.week.iso8601)
        when "1–2 semanas"
          qi.update(gestational_age_low: 1.week.iso8601, gestational_age_high: 2.weeks.iso8601)
        when "3–4 semanas"
          qi.update(gestational_age_low: 3.weeks.iso8601, gestational_age_high: 4.weeks.iso8601)
        when "I trimestre"
          qi.update(gestational_age_high: 3.months.iso8601)
        when "II trimestre"
          qi.update(gestational_age_low: 3.months.iso8601, gestational_age_high: 6.months.iso8601)
        when "III trimestre"
          qi.update(gestational_age_low: 6.months.iso8601)
        when "1–2 meses"
          qi.update(gestational_age_low: 1.month.iso8601, gestational_age_high: 2.months.iso8601)
        when "2–3 meses"
          qi.update(gestational_age_low: 2.months.iso8601, gestational_age_high: 3.months.iso8601)
        when "Positivo"
          qi.update(interpretation: LabTestValue.find_by(loinc: "LA6576-8"))
        when "Negativo"
          qi.update(interpretation: LabTestValue.find_by(loinc: "LA6577-6"))
        when "Zona gris"
          qi.update(interpretation: LabTestValue.find_by(loinc: "LA11885-3"))
        when "Crítico"
          qi.update(category: "critical")
        end
        Rails.logger.debug "."
      end
    end

    Rails.logger.debug ""
  end
end
