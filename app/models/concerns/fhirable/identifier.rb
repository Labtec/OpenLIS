# frozen_string_literal: true

module FHIRable
  module Identifier
    extend ActiveSupport::Concern

    def fhirable_observation_identifier
      [
        {
          use: "official",
          system: to_gid,
          value: id
        }
      ]
    end

    def fhirable_patient_identifier
      return if identifier.blank?

      [
        {
          use: "official",
          type: {
            coding: [
              system: "http://terminology.hl7.org/CodeSystem/v2-0203",
              code: fhirable_identifier_code
            ]
          },
          value: identifier
        },
        fhirable_identifier_member_number
      ].compact
    end

    private

    def fhirable_identifier_code
      identifier_type == 1 ? "MR" : "PPN"
    end

    def fhirable_identifier_member_number
      return if policy_number.blank?

      {
        type: {
          coding: [
            system: "http://terminology.hl7.org/CodeSystem/v2-0203",
            code: "MB"
          ]
        },
        value: policy_number
      }
    end
  end
end
