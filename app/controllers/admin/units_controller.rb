# frozen_string_literal: true

module Admin
  class UnitsController < BaseController
    before_action :set_unit, only: %i[show edit update destroy]

    def index
      @units = Unit.all
    end

    def show; end

    def new
      @unit = Unit.new
    end

    def edit; end

    def create
      @unit = Unit.new(unit_params)

      if @unit.save
        redirect_to [:admin, @unit], notice: 'Unit was successfully created.'
      else
        render :new
      end
    end

    def update
      if @unit.update(unit_params)
        redirect_to [:admin, @unit], notice: 'Unit was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @unit.destroy
      redirect_to admin_units_url, notice: 'Unit was successfully destroyed.'
    end

    private

    def set_unit
      @unit = Unit.find(params[:id])
    end

    def unit_params
      params.require(:unit).permit(:conversion_factor, :expression, :si, :ucum)
    end
  end
end
