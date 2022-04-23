# frozen_string_literal: true

module Admin
  class DoctorsController < BaseController
    before_action :set_doctor, only: %i[edit update destroy]

    def index
      @doctors = Doctor.all
    end

    def new
      @doctor = Doctor.new
    end

    def edit; end

    def create
      @doctor = Doctor.new(doctor_params)

      if @doctor.save
        redirect_to admin_doctors_url, notice: 'Successfully created doctor.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @doctor.update(doctor_params)
        redirect_to admin_doctors_url, notice: 'Successfully updated doctor.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @doctor.destroy

      respond_to do |format|
        format.html { redirect_to admin_doctors_url, notice: 'Successfully deleted doctor.' }
        format.turbo_stream { flash.now[:notice] = 'Successfully deleted doctor.' }
      end
    end

    private

    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:email, :name)
    end
  end
end
