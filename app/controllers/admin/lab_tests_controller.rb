# frozen_string_literal: true

module Admin
  class LabTestsController < BaseController
    def index
      @lab_tests = LabTest.all.includes(:department, :unit).order(position: :asc).group_by(&:department_name)
    end

    def show
      @lab_test = LabTest.find(params[:id])
    end

    def new
      @lab_test = LabTest.new
    end

    def create
      @lab_test = LabTest.new(lab_test_params)
      if @lab_test.save
        flash[:notice] = 'Successfully created lab test.'
        redirect_to [:admin, @lab_test]
      else
        render action: 'new'
      end
    end

    def edit
      @lab_test = LabTest.find(params[:id])
    end

    def update
      @lab_test = LabTest.find(params[:id])
      if @lab_test.update_attributes(lab_test_params)
        flash[:notice] = 'Successfully updated lab test.'
        redirect_to [:admin, @lab_test]
      else
        render action: 'edit'
      end
    end

    def destroy
      @lab_test = LabTest.find(params[:id])
      @lab_test.destroy
      flash[:notice] = 'Successfully destroyed lab test.'
      redirect_to admin_lab_tests_url
    end

    def sort
      params[:lab_test].each_with_index do |id, index|
        LabTest.where(id: id).update_all(position: index + 1)
      end
      head :ok
    end

    private

    def lab_test_params
      params.require(:lab_test).permit(:also_allow, :code, :name, :description, :decimals, :department_id, :unit_id, :procedure, :derivation, :also_numeric, :ratio, :range, :fraction, :text_length, lab_test_value_ids: [])
    end
  end
end
