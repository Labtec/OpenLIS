class HealthCardPayload < HealthCards::Payload
  allow type: FHIR::Patient, attributes: %w[name gender birthDate]
  allow type: FHIR::Observation,
        attributes: %w[
          meta status code subject effectiveDateTime effectivePeriod issued
          valueCodeableConcept valueQuantity note referenceRange
        ]
end
