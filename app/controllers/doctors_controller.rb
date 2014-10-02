class DoctorsController < ApplicationController
  before_filter :require_user

  def index
    @doctors = Doctor.limit(10).search_for_name(params[:term])

    respond_to do |format|
      format.json { render :json => @doctors.map(&:name) }
    end
  end
end
