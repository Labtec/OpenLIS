# frozen_string_literal: true

module LabConnect
  class DiagnosticReportsController < BaseController
    before_action :set_diagnostic_report, only: %i[ update ]

    def update
      if @diagnostic_report.update(diagnostic_report_params)
        @diagnostic_report.transaction do
          @diagnostic_report.lock!
          @diagnostic_report.results.map(&:evaluate!)
          @diagnostic_report.evaluate!
        end

        render json: @diagnostic_report
      else
        render json: @diagnostic_report.errors, status: :unprocessable_entity
      end
    end

    private

    def set_diagnostic_report
      @diagnostic_report = Accession.find(params[:id])
    end

    def diagnostic_report_params
      params.permit(diagnostic_report: [
        { results_attributes: %i[id lab_test_value_id value] },
        notes_attributes: %i[id content department_id]
      ]).require(:diagnostic_report)
    end
  end
end
