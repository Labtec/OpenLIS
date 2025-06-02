# frozen_string_literal: true

module Admin
  class LabTestsController < BaseController
    before_action :set_lab_test, only: %i[show edit update destroy sort]

    def index
      @departments = Department.includes({ lab_tests: [ :unit ] })
    end

    def show; end

    def new
      @lab_test = LabTest.new
    end

    def edit; end

    def create
      @lab_test = LabTest.new(lab_test_params)

      if @lab_test.save
        redirect_to admin_lab_tests_url, notice: "Successfully created lab test."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @lab_test.update(lab_test_params)
        redirect_to admin_lab_tests_url, notice: "Successfully updated lab test."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @lab_test.destroy

      respond_to do |format|
        format.html { redirect_to admin_lab_tests_url, notice: "Successfully destroyed lab test." }
        format.turbo_stream { flash.now[:notice] = "Successfully destroyed lab test." }
      end
    end

    def sort
      insert_at_position(params[:position].to_i)

      head :ok
    end

    private

    def set_lab_test
      @lab_test = LabTest.find(params[:id])
    end

    def lab_test_params
      params.permit(lab_test: [
        :also_allow,
        :code,
        :name,
        :description,
        :decimals,
        :department_id,
        :unit_id,
        :procedure,
        :procedure_quantity,
        :loinc,
        :derivation,
        :also_numeric,
        :ratio,
        :range,
        :fraction,
        :text_length,
        :remarks,
        :fasting_status_duration_iso8601,
        :patient_preparation,
        :status,
        lab_test_value_ids: []
      ]).require(:lab_test)
    end

    def insert_at_position(position)
      if position.zero?
        @lab_test.move_to_top
      else
        @lab_test.insert_at(position + 1)
      end
    end
  end
end
