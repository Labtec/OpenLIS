# frozen_string_literal: true

class ResultsController < ApplicationController
  def index
    @accession = Accession.find(params[:accession_id])
    @patient = @accession.patient
    @results = @accession.results.includes({ accession: { notes: [:department] } }, { lab_test: [:department] }, :lab_test_value, :reference_ranges, :unit).order('lab_tests.position').group_by(&:department)

    pdf = LabReport.new(@patient, @accession, @results, view_context)
    send_data(pdf.render, filename: "resultados_#{@accession.id}.pdf",
                          type: 'application/pdf', disposition: 'inline')
  end
end
