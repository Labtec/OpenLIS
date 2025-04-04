# frozen_string_literal: true

require "csv"

module FHIRable
  module Observation
    extend ActiveSupport::Concern
    include Identifier
    include FHIRable::Reference
    include FHIRable::Range
    include FHIRable::Ratio

    included do
      def self.new_from_fhir(contents)
        bundle = FHIR.from_contents(contents)
        observation = ""

        if bundle.try(:entry)
          bundle.entry.each do |e|
            next if e.resource.resourceType != "Observation"

            observation = e.resource
            break
          end
        else
          observation = bundle
        end

        # TODO
        # new(
        #   value: observation_value_x,
        #   lab_test_value: observation_value_codeable_concept,
        #   lab_test: observation_lab_test,
        #   accession:  observation_specimen,
        #   status: observation.status,
        #   data_absent_reason: observation.data_absent_reason
        # )
      end
    end

    def fhirable_observation
      # TODO: implement meta.security
      # - N PDS
      # - DRUG
      # - HIV
      # - PREGNANT
      # - SCA SICKLE
      # - SEX
      # - STD
      FHIR::Observation.new(
        id:,
        identifier: fhirable_observation_identifier,
        basedOn: FHIR::Reference.new(reference: "ServiceRequest/#{accession.id}"),
        status:,
        category: FHIR::CodeableConcept.new(coding: [ FHIR::Coding.new(system: "http://terminology.hl7.org/CodeSystem/observation-category", code: "laboratory") ]),
        # 'code': FHIR::CodeableConcept.new(coding: [FHIR::Coding.new(system: 'http://loinc.org', code: lab_test&.loinc, display: display_loinc(lab_test&.loinc))]),
        code: FHIR::CodeableConcept.new(text: lab_test.stripped_name, coding: [ FHIR::Coding.new(system: "http://loinc.org", code: lab_test&.loinc) ]),
        subject: fhirable_reference(patient),
        effectiveDateTime: drawn_at.utc.iso8601,
        issued: reported_at&.utc&.iso8601,
        performer: observation_performers,
        valueQuantity: observation_value_quantity,
        valueCodeableConcept: observation_value_codeable_concept,
        valueString: observation_value_string,
        valueBoolean: observation_value_boolean,
        valueInteger: observation_value_integer,
        valueRange: observation_value_range,
        valueRatio: observation_value_ratio,
        dataAbsentReason: observation_data_absent_reason,
        interpretation: observation_interpretations(interpretation),
        note: observation_notes,
        bodySite: observation_body_site,
        method: observation_method,
        specimen: fhirable_reference(accession),
        referenceRange: observation_reference_ranges
      )
    end

    def to_json(_options = {})
      fhirable_observation.to_json
    end

    def to_xml(_options = {})
      fhirable_observation.to_xml
    end

    private

    def observation_data_absent_reason
      return unless data_absent_reason

      FHIR::CodeableConcept.new(coding: [ FHIR::Coding.new(system: "http://terminology.hl7.org/CodeSystem/data-absent-reason", code: data_absent_reason) ])
    end

    def observation_performers
      # XXX: Use PractitionerRole
      performers = []
      performers << fhirable_reference(accession.drawer) if accession.drawer
      performers << fhirable_reference(accession.receiver) if accession.receiver
      performers << fhirable_reference(accession.reporter) if accession.reporter
      performers.uniq
    end

    def observation_interpretations(interpretation)
      return unless interpretation

      [
        FHIR::CodeableConcept.new(
          coding: FHIR::Coding.new(
            system: "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
            code: interpretation,
            display: lookup_interpretation(interpretation)
          )
        )
      ]
    end

    def observation_notes
      return unless lab_test_remarks || derived_remarks

      notes = []
      # XXX Apple does not parse markdown
      notes << FHIR::Annotation.new(text: lab_test_remarks) if lab_test_remarks
      notes << FHIR::Annotation.new(text: derived_remarks) if derived_remarks

      notes
    end

    def lookup_interpretation(flag)
      index = ApplicationController.helpers.options_for_flag.flatten.index(flag)
      ApplicationController.helpers.options_for_flag.flatten[index - 1] if index
    end

    def observation_reference_ranges
      return if reference_ranges.blank?

      ranges = []
      reference_intervals.each do |range|
        ranges << {
          low: fhirable_quantity(range.range.begin, decimal_precision: lab_test.decimals.to_i, unit: lab_test.unit),
          high: fhirable_quantity(range.range.end, decimal_precision: lab_test.decimals.to_i, unit: lab_test.unit),
          type: observation_reference_ranges_type(range.context),
          text: range.condition
        }
      end
      ranges
    end

    def observation_reference_ranges_type(type)
      return unless type

      FHIR::CodeableConcept.new(
        coding: FHIR::Coding.new(
          system: "http://terminology.hl7.org/CodeSystem/referencerange-meaning",
          code: type,
          display: lookup_type(type)
        )
      )
    end

    def lookup_type(type)
      index = ApplicationController.helpers.options_for_context.flatten.index(type)
      ApplicationController.helpers.options_for_context.flatten[index - 1]
    end

    def observation_value_quantity
      return unless value_quantity.is_a? Numeric
      return if value_quantity.is_a? Rational
      return unless derived_value || value.present?

      comparator_hash_lookup = {
        "<" => "<",
        "≤" => "<=",
        "≥" => ">=",
        ">" => ">"
      }

      FHIR::Quantity.new(
        value: observation_value_quantity_value,
        comparator: comparator_hash_lookup[value_quantity_comparator],
        unit: value_unit,
        system: "http://unitsofmeasure.org",
        code: lab_test.customary_unit
      )
    end

    def observation_value_quantity_value
      return unless value_quantity.is_a?(Numeric) && value_quantity.finite?

      ApplicationController.helpers.number_with_precision(value_quantity, precision: lab_test_decimals)
    end

    def observation_value_range
      return unless value_range

      fhirable_range(value_range, unit:)
    end

    def observation_value_ratio
      return unless value_ratio

      fhirable_ratio(value_ratio, unit:)
    end

    def observation_value_codeable_concept
      return if value_codeable_concept.blank?

      codes = []
      codes << FHIR::Coding.new(system: "http://loinc.org", code: lab_test_value&.loinc) if lab_test_value&.loinc.present?
      codes << FHIR::Coding.new(system: "http://snomed.info/sct", code: lab_test_value&.snomed) if lab_test_value&.snomed.present?

      return if codes.empty?

      FHIR::CodeableConcept.new(coding: codes, text: lab_test_value.stripped_value)
    end

    # XXX: Use a read only table
    def display_loinc(code)
      loinc ||= CSV.read("db/LoincTableCore.csv", headers: true)
      lookup = loinc.find { |row| row["LOINC_NUM"] == code }
      lookup["LONG_COMMON_NAME"]
    end

    # TODO: implement each missing method
    def method_missing(*_args)
      nil
    end
  end
end
