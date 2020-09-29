# frozen_string_literal: true

class ResultsController < ApplicationController
  def index
    @accession = Accession.find(params[:accession_id])
    @patient = @accession.patient
    @results = @accession.results.includes(:department, :lab_test_value, { lab_test: [:reference_ranges] }, :reference_ranges, :patient, :unit).ordered.group_by(&:department)

    pdf = LabReport.new(@patient, @accession, @results, false, view_context)
    send_data(pdf.render, filename: "resultados_#{@accession.id}.pdf",
                          type: 'application/pdf', disposition: 'inline')
  end
end
