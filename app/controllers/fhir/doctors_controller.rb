# frozen_string_literal: true

module FHIR
  class DoctorsController < BaseController
    before_action :set_doctor, only: %i[show]

    def show
      render json: @doctor
    end

    private

    def set_doctor
      @doctor = Doctor.find_by(uuid: params[:id])
    end
  end
end
