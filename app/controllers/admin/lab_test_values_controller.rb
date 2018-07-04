# frozen_string_literal: true

module Admin
  class LabTestValuesController < BaseController
    def index
      @lab_test_values = LabTestValue.sorted
    end

    def show
      @lab_test_value = LabTestValue.find(params[:id])
    end

    def new
      @lab_test_value = LabTestValue.new
    end

    def create
      @lab_test_value = LabTestValue.new(lab_test_value_params)
      if @lab_test_value.save
        flash[:notice] = 'Successfully created lab test value.'
        redirect_to [:admin, @lab_test_value]
      else
        render action: 'new'
      end
    end

    def edit
      @lab_test_value = LabTestValue.find(params[:id])
    end

    def update
      @lab_test_value = LabTestValue.find(params[:id])
      if @lab_test_value.update(lab_test_value_params)
        flash[:notice] = 'Successfully updated lab test value.'
        redirect_to [:admin, @lab_test_value]
      else
        render action: 'edit'
      end
    end

    def destroy
      @lab_test_value = LabTestValue.find(params[:id])
      @lab_test_value.destroy
      flash[:notice] = 'Successfully destroyed lab test value.'
      redirect_to admin_lab_test_values_url
    end

    private

    def lab_test_value_params
      params.require(:lab_test_value).permit(:value, :flag, :numeric, :note)
    end
  end
end
