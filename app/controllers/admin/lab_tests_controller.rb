# frozen_string_literal: true

module Admin
  class LabTestsController < BaseController
    before_action :set_lab_test, only: %i[show edit update destroy]

    def index
      @lab_tests = LabTest.all.includes(:department, :unit).order(:position).group_by(&:department_name)
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
      params[:lab_test].each.with_index(1) do |id, index|
        LabTest.where(id: id).update_all(position: index)
      end

      head :ok
    end

    private

    def set_lab_test
      @lab_test = LabTest.find(params[:id])
    end

    def lab_test_params
      params.require(:lab_test).permit(:also_allow, :code, :name, :description, :decimals, :department_id, :unit_id, :procedure, :loinc, :derivation, :also_numeric, :ratio, :range, :fraction, :text_length, :remarks, lab_test_value_ids: [])
    end
  end
end
