# frozen_string_literal: true

module Admin
  class LabTestValuesController < BaseController
    before_action :set_lab_test_value, only: %i[edit update destroy]

    def index
      @lab_test_values = LabTestValue.sorted
    end

    def new
      @lab_test_value = LabTestValue.new
    end

    def edit; end

    def create
      @lab_test_value = LabTestValue.new(lab_test_value_params)

      if @lab_test_value.save
        redirect_to admin_lab_test_values_url, notice: "Successfully created lab test value."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @lab_test_value.update(lab_test_value_params)
        redirect_to admin_lab_test_values_url, notice: "Successfully updated lab test value."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @lab_test_value.destroy

      respond_to do |format|
        format.html { redirect_to admin_lab_test_values_url, notice: "Successfully destroyed lab test value." }
        format.turbo_stream { flash.now[:notice] = "Successfully destroyed lab test value." }
      end
    end

    private

    def set_lab_test_value
      @lab_test_value = LabTestValue.find(params[:id])
    end

    def lab_test_value_params
      params.require(:lab_test_value).permit(:value, :flag, :loinc, :numeric, :note, :snomed)
    end
  end
end
