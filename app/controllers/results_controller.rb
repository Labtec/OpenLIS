class ResultsController < ApplicationController
  def index
    @accession = Accession.find(params[:accession_id])
    @patient = @accession.patient
    @results = @accession.results.group_by(&:department) #(:order: 'lab_tests.position', include: [{accession: :patient}, {lab_test: [:department, :unit]}, :lab_test_value]).group_by(&:department)

    pdf = LabReport.new(@patient, @accession, @results, view_context)
    send_data(pdf.render, filename: "resultados_#{@accession.id}.pdf",
      type: 'application/pdf', disposition: 'inline')
  end
end
