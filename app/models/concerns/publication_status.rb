# frozen_string_literal: true

module PublicationStatus
  extend ActiveSupport::Concern

  included do
    # http://hl7.org/fhir/valueset-publication-status.html
    attribute :status, :string
    enum :status, %w[
      draft
      active
      retired
      unknown
    ].index_by(&:itself)
  end
end
