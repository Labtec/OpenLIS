# frozen_string_literal: true

module Admin
  class UnitsController < BaseController
    def index
      @units = Unit.all
    end

    def show
      @unit = Unit.find(params[:id])
    end

    def new
      @unit = Unit.new
    end

    def create
      @unit = Unit.new(unit_params)
      if @unit.save
        flash[:notice] = 'Successfully created unit.'
        redirect_to [:admin, @unit]
      else
        render action: 'new'
      end
    end

    def edit
      @unit = Unit.find(params[:id])
    end

    def update
      @unit = Unit.find(params[:id])
      if @unit.update(unit_params)
        flash[:notice] = 'Successfully updated unit.'
        redirect_to [:admin, @unit]
      else
        render action: 'edit'
      end
    end

    def destroy
      @unit = Unit.find(params[:id])
      @unit.destroy
      flash[:notice] = 'Successfully destroyed unit.'
      redirect_to admin_units_url
    end

    private

    def unit_params
      params.require(:unit).permit(:name)
    end
  end
end
