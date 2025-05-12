# frozen_string_literal: true

module FHIR
  class DiagnosticReportsController < BaseController
    before_action :set_diagnostic_report, only: %i[show]

    def show
      render json: @diagnostic_report
    end

    private

    def set_diagnostic_report
      @diagnostic_report = Accession.find(params[:id])
    end
  end
end
