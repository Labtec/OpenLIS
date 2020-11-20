# frozen_string_literal: true

module Admin
  class DepartmentsController < BaseController
    def index
      @departments = Department.order('id asc').includes(:lab_tests)
    end

    def new
      @department = Department.new
      render layout: false
    end

    def create
      @department = Department.new(department_params)
      if @department.save
        flash[:notice] = 'Department created successfully.'
        redirect_to admin_departments_url
      else
        render action: 'new'
      end
    end

    def edit
      @department = Department.find(params[:id])
    end

    def update
      @department = Department.find(params[:id])
      if @department.update(department_params)
        flash[:notice] = 'Department updated successfully.'
        redirect_to admin_departments_url
      else
        render action: 'edit'
      end
    end

    def destroy
      @department = Department.find(params[:id])
      @department.destroy
      flash[:notice] = 'Department deleted.'
      redirect_to admin_departments_url
    end

    private

    def department_params
      params.require(:department).permit(:code, :loinc_class, :name)
    end
  end
end
