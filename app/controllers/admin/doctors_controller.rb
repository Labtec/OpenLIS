class Admin::DoctorsController < Admin::ApplicationController
  def index
    @doctors = Doctor.all
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)
    if @doctor.save
      flash[:notice] = "Successfully created doctor."
      redirect_to [:admin, @doctor]
    else
      render action: 'new'
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
  end

  def update
    @doctor = Doctor.find(params[:id])
    if @doctor.update_attributes(doctor_params)
      flash[:notice] = "Successfully updated doctor."
      redirect_to [:admin, @doctor]
    else
      render action: 'edit'
    end
  end

  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy
    flash[:notice] = "Successfully deleted doctor."
    redirect_to admin_doctors_url
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name)
  end
end
