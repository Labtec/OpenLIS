# frozen_string_literal: true

module PublicationStatus
  extend ActiveSupport::Concern

  included do

    # http://hl7.org/fhir/valueset-publication-status.html
    enum status: {
      draft:   'draft',
      active:  'active',
      retired: 'retired',
      unknown: 'unknown'
    }
  end
end
