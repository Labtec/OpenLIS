# frozen_string_literal: true

module Admin
  class LabTestsController < BaseController
    before_action :set_lab_test, only: %i[show edit update destroy]

    def index
      @departments = Department.all.includes({ lab_tests: [:unit] })
    end

    def show; end

    def new
      @lab_test = LabTest.new
    end

    def edit; end

    def create
      @lab_test = LabTest.new(lab_test_params)

      if @lab_test.save
        redirect_to admin_lab_tests_url, notice: 'Successfully created lab test.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @lab_test.update(lab_test_params)
        redirect_to admin_lab_tests_url, notice: 'Successfully updated lab test.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @lab_test.destroy

      respond_to do |format|
        format.html { redirect_to admin_lab_tests_url, notice: 'Successfully destroyed lab test.' }
        format.turbo_stream { flash.now[:notice] = 'Successfully destroyed lab test.' }
      end
    end

    def sort
      move_from_to(params[:src_list].to_i, params[:src_item].to_i, params[:dst_list].to_i, params[:dst_item].to_i)

      head :ok
    end

    private

    def set_lab_test
      @lab_test = LabTest.find(params[:id])
    end

    def lab_test_params
      params.require(:lab_test).permit(:also_allow, :code, :name, :description, :decimals, :department_id, :unit_id, :procedure, :loinc, :derivation, :also_numeric, :ratio, :range, :fraction, :text_length, :remarks, :fasting_status_duration_iso8601, :patient_preparation, :status, lab_test_value_ids: [])
    end

    def move_from_to(src_department_position, src_lab_test_position, dst_department_position, dst_lab_test_position)
      src_department, dst_department = Department.unscoped.where(
        position: [src_department_position, dst_department_position]
      )
      @lab_test = src_department.lab_tests.find_by_position(src_lab_test_position)
      if dst_department
        @lab_test.update(department: dst_department)
        @lab_test.insert_at(dst_lab_test_position)
      else
        @lab_test.insert_at(dst_lab_test_position)
      end
    end
  end
end
