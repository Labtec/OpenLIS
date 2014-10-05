class DoctorsController < ApplicationController
  def index
    @doctors = Doctor.search_for_name(params[:term]).limit(10)

    respond_to do |format|
      format.json { render json: @doctors.map(&:name) }
    end
  end
end
