class LabResultPayload < HealthCards::Payload
  additional_types 'https://smarthealth.cards#laboratory'

  allow type: FHIR::Patient, attributes: %w[name gender birthDate]
  allow type: FHIR::Observation,
        attributes: %w[
          meta status code subject effectiveDateTime effectivePeriod issued
          valueCodeableConcept valueQuantity note referenceRange
        ]
end

class COVIDLabResultPayload < LabResultPayload
  additional_types 'https://smarthealth.cards#covid19'
end
