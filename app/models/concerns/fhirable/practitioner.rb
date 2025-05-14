# frozen_string_literal: true

module FHIRable
  module Practitioner
    extend ActiveSupport::Concern
    include Communication
    include Name
    include Telecom

    def fhirable_practitioner
      practitioner = FHIR::Practitioner.new(
        id: uuid,
        active: fhirable_active,
        name: fhirable_practitioner_name,
        gender: gender,
        # birthDate: birthdate,
        # deceasedBoolean: deceased?,
        # address: fhirable_address,
        # photo:,
        # qualification: register,
        # communication: fhirable_communication
      )
      practitioner.telecom = fhirable_practitioner_telecom if fhirable_practitioner_telecom.any?

      practitioner
    end

    def to_json(_options = {})
      fhirable_practitioner.to_json
    end

    def to_xml(_options = {})
      fhirable_practitioner.to_xml
    end

    def fhirable_active
      true
    end
  end
end
