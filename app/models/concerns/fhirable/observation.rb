# frozen_string_literal: true

module FHIRable
  module Observation
    extend ActiveSupport::Concern
    include Identifier
    include FHIRable::Range

    included do
      def self.new_from_fhir(contents)
        bundle = FHIR.from_contents(contents)
        observation = ''

        if bundle.try(:entry)
          bundle.entry.each do |e|
            next if e.resource.resourceType != 'Observation'

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
      FHIR::Observation.new(
        'id': id,
        'identifier': fhirable_observation_identifier,
        'basedOn': FHIR::Reference.new(reference: "ServiceRequest/#{accession.id}", type: 'ServiceRequest'),
        'status': status,
        'category': FHIR::CodeableConcept.new(coding: [FHIR::Coding.new(system: 'http://terminology.hl7.org/CodeSystem/observation-category', code: 'laboratory')]),
        'code': FHIR::CodeableConcept.new(coding: [FHIR::Coding.new(system: 'http://loinc.org', code: lab_test&.loinc, display: 'TODO_LOINC_CODE_LOOKUP')]),
        'subject': FHIR::Reference.new(reference: "Patient/#{patient.id}", type: 'Patient', display: 'TODO_PATIENT_FULL_NAME'),
        'issued': created_at.iso8601,
        'performer': observation_performers,
        'valueQuantity': observation_value_quantity,
        'valueCodeableConcept': observation_value_codeable_concept,
        'valueString': observation_value_string,
        'valueBoolean': observation_value_boolean,
        'valueInteger': observation_value_integer,
        'valueRange': observation_value_range,
        'valueRatio': observation_value_ratio,
        'dataAbsentReason': observation_data_absent_reason,
        'interpretation': observation_interpretations(interpretation),
        'note': observation_notes,
        'bodySite': observation_body_site,
        'method': observation_method,
        'specimen': FHIR::Reference.new(reference: "Specimen/#{accession.id}", type: 'Specimen'),
        'referenceRange': observation_reference_ranges
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

      FHIR::CodeableConcept.new(coding: [FHIR::Coding.new(system: 'http://terminology.hl7.org/CodeSystem/data-absent-reason', code: data_absent_reason)])
    end

    def observation_performers
      # XXX: Use PractitionerRole
      [
        FHIR::Reference.new(reference: "Practitioner/#{accession.drawer.id}", tpe: 'Practitioner', display: 'TODO_PRACTITIONER_FULL_NAME'),
        FHIR::Reference.new(reference: "Practitioner/#{accession.reporter&.id}", tpe: 'Practitioner', display: 'TODO_PRACTITIONER_FULL_NAME')
      ]
    end

    def observation_interpretations(interpretation)
      return unless interpretation

      [
        FHIR::CodeableConcept.new(
          coding: FHIR::Coding.new(
            system: 'http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation',
            code: interpretation,
            display: lookup_interpretation(interpretation)
          )
        )
      ]
    end

    def lookup_interpretation(flag)
      index = ApplicationController.helpers.options_for_flag.flatten.index(flag)
      ApplicationController.helpers.options_for_flag.flatten[index - 1]
    end

    def observation_reference_ranges
      return if reference_ranges.blank?

      ranges = []
      reference_ranges.each do |range|
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
          system: 'http://terminology.hl7.org/CodeSystem/referencerange-meaning',
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
      return unless derived_value || value.present?

      FHIR::Quantity.new(
        'value': observation_value_quantity_value,
        'comparator': observation_value_quantity_comparator,
        'unit': value_unit,
        'system': 'http://unitsofmeasure.org',
        'code': lab_test.customary_unit
      )
    end

    def observation_value_quantity_comparator
      quantity_comparator = strip_quantity_comparator(value)
      return unless quantity_comparator

      case quantity_comparator
      when '<'
        '<'
      when '<=', '≤'
        '<='
      when '>=', '≥'
        '>='
      when '>'
        '>'
      end
    end

    def observation_value_quantity_value
      quantity_value = derivation? ? derived_value : value

      ApplicationController.helpers.number_with_precision(quantity_value, precision: lab_test_decimals)
    end

    # TODO: implement each missing method
    def method_missing(*_args)
      nil
    end
  end
end
