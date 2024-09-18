class AddStatusColumn < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      -- http://hl7.org/fhir/valueset-data-absent-reason.html
      CREATE TYPE data_absent_reason AS ENUM ('unknown', 'asked-unknown', 'temp-unknown', 'not-asked', 'asked-declined', 'masked', 'not-applicable', 'unsupported', 'as-text', 'error', 'not-a-number', 'negative-infinity', 'positive-infinity', 'not-performed', 'not-permitted');

      -- http://hl7.org/fhir/valueset-diagnostic-report-status.html
      CREATE TYPE diagnostic_report_status AS ENUM ('registered', 'partial', 'preliminary', 'final', 'amended', 'corrected', 'appended', 'cancelled', 'entered-in-error', 'unknown');

      -- http://hl7.org/fhir/valueset-observation-status.html
      CREATE TYPE observation_status AS ENUM ('registered', 'preliminary', 'final', 'amended', 'corrected', 'cancelled', 'entered-in-error', 'unknown');
    SQL

    add_column :accessions, :status, :diagnostic_report_status
    add_column :observations, :status, :observation_status
    add_column :observations, :data_absent_reason, :data_absent_reason

    execute <<-SQL
      UPDATE observations SET status = 'registered';
      UPDATE accessions SET status = 'registered';
    SQL

    populate_status_column
  end

  def down
    remove_column :accessions, :status
    remove_column :observations, :status
    remove_column :observations, :data_absent_reason

    execute <<-SQL
      DROP TYPE data_absent_reason;
      DROP TYPE diagnostic_report_status;
      DROP TYPE observation_status;
    SQL
  end

  private

  def populate_status_column
    puts "Updating observations"

    ActiveRecord::Base.transaction do
      cancelled_observations.find_each do |observation|
        observation.not_performed!
        observation.update_columns(status: "cancelled")
        print "."
      end

      final_observations.find_each do |observation|
        observation.update_columns(status: "final")
        print "."
      end

      preliminary_observations.find_each do |observation|
        observation.update_columns(status: "preliminary")
        print "."
      end

      derived_observations
    end

    final_accessions = Accession.where.not(reported_at: nil)
    partial_accessions = Accession.includes(:results).where(reported_at: nil)

    puts "Updating diagnostic reports"

    ActiveRecord::Base.transaction do
      puts "Updating final diagnostic reports"
      final_accessions.find_each do |accession|
        accession.update_columns(status: "final")
        print "."
      end

      puts "Updating partial/preliminary diagnostic reports"
      partial_accessions.find_each do |accession|
        if accession.results.map(&:status).any? "registered"
          accession.update_columns(status: "partial")
        else
          accession.update_columns(status: "preliminary")
        end
        print "."
      end
    end

    puts " Done!"
  end

  def derived_observations
    observations = Observation.joins(:lab_test).where({ lab_tests: { derivation: true } })

    observations.find_each do |observation|
      if observation.derived_value
        if observation.accession.reported_at
          observation.update_columns(status: "final")
        else
          observation.update_columns(status: "preliminary")
        end
      elsif observation.accession.reported_at
        observation.not_performed!
        observation.update_columns(status: "cancelled")
      end
      print "."
    end
  end

  def cancelled_observations
    Observation.joins(:accession, :lab_test).where(value: nil).where(lab_test_value_id: nil).where.not(accessions: { reported_at: nil }).where.not(lab_tests: { derivation: true })
  end

  def final_observations
    Observation.joins(:accession).where.not(value: nil).where.not(accessions: { reported_at: nil }).or(Observation.joins(:accession).where.not(lab_test_value_id: nil).where.not(accessions: { reported_at: nil }))
  end

  def preliminary_observations
    Observation.joins(:accession).where.not(value: nil).where(accessions: { reported_at: nil }).or(Observation.joins(:accession).where.not(lab_test_value_id: nil).where(accessions: { reported_at: nil }))
  end
end
