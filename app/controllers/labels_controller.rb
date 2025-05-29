# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_specimen, only: %i[show]

  def show
    respond_to do |format|
      format.pdf do
        pdf = Label.new(@patient, @specimen, view_context)
        send_data(pdf.render, filename: "label_#{@specimen.id}.pdf",
                              type: "application/pdf", disposition: "inline")
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to diagnostic_reports_url
  end

  private

  def set_specimen
    @specimen = Accession.includes(:patient).find(params[:id])
    @patient = @specimen.patient
  end
end
