# frozen_string_literal: true

module Admin
  class DepartmentsController < BaseController
    before_action :set_department, only: %i[edit update destroy]

    def index
      @departments = Department.order("id asc").includes(:lab_tests)
    end

    def new
      @department = Department.new
      render layout: false
    end

    def edit; end

    def create
      @department = Department.new(department_params)

      if @department.save
        redirect_to admin_departments_url, notice: "Department created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @department.update(department_params)
        redirect_to admin_departments_url, notice: "Department updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @department.destroy

      respond_to do |format|
        format.html { redirect_to admin_departments_url, notice: "Department deleted." }
        format.turbo_stream { flash.now[:notice] = "Department deleted." }
      end
    end

    private

    def set_department
      @department = Department.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:code, :loinc_class, :name)
    end
  end
end
