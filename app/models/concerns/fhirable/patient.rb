# frozen_string_literal: true

module FHIRable
  module Patient
    extend ActiveSupport::Concern
    include Address
    include Animal
    include Communication
    include Identifier
    include Name
    include Telecom

    ADMINISTRATIVE_GENDERS = {
      'M' => 'male',
      'F' => 'female',
      'O' => 'other',
      'U' => 'unknown'
    }.freeze

    ANIMAL_SPECIES = {
      1 => 'canislf'
    }.freeze

    included do
      def self.new_from_fhir(contents)
        bundle = FHIR.from_contents(contents)
        patient = ''
        animal_species = ''

        if bundle.try(:entry)
          bundle.entry.each do |e|
            next if e.resource.resourceType != 'Patient'

            patient = e.resource
            break
          end
        else
          patient = bundle
        end

        patient.extension.each do |e|
          next unless e.url == 'http://hl7.org/fhir/StructureDefinition/patient-animal'

          animal_species = ANIMAL_SPECIES.key(e.species.coding.first.code)
          break
        end

        new(
          given_name: patient.name.first.given.first,
          middle_name: patient.name.first.given.second,
          family_name: patient.name.first.family,
          birthdate: patient.birthDate,
          identifier: patient.identifier.first.value,
          identifier_type: 0,
          gender: ADMINISTRATIVE_GENDERS.key(patient.gender),
          animal_type: animal_species
        )
      end
    end

    def fhirable_patient
      FHIR::Patient.new(
        'extension': fhirable_animal,
        'id': id,
        'active': true,
        'identifier': fhirable_identifier,
        'name': fhirable_name,
        'telecom': fhirable_telecom,
        'gender': ADMINISTRATIVE_GENDERS[gender],
        'birthDate': birthdate,
        'deceasedBoolean': deceased?,
        'address': fhirable_address
      )
    end

    def to_json(_options = {})
      fhirable_patient.to_json
    end

    def to_xml(_options = {})
      fhirable_patient.to_xml
    end
  end
end
