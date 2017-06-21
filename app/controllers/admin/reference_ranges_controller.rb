# frozen_string_literal: true

module Admin
  class ReferenceRangesController < BaseController
    def index
      @reference_ranges = ReferenceRange.all.includes(:lab_test).order(:lab_test_id, :age_unit, :min_age)
    end

    def show
      @reference_range = ReferenceRange.find(params[:id])
    end

    def new
      @reference_range = ReferenceRange.new
    end

    def create
      @reference_range = ReferenceRange.new(reference_range_params)
      if @reference_range.save
        flash[:notice] = 'Successfully created reference range.'
        redirect_to [:admin, @reference_range]
      else
        render action: 'new'
      end
    end

    def edit
      @reference_range = ReferenceRange.find(params[:id])
    end

    def update
      @reference_range = ReferenceRange.find(params[:id])
      if @reference_range.update(reference_range_params)
        flash[:notice] = 'Successfully updated reference range.'
        redirect_to [:admin, @reference_range]
      else
        render action: 'edit'
      end
    end

    def destroy
      @reference_range = ReferenceRange.find(params[:id])
      @reference_range.destroy
      flash[:notice] = 'Successfully removed reference range.'
      redirect_to admin_reference_ranges_url
    end

    private

    def reference_range_params
      params.require(:reference_range).permit(:min, :max, :gender, :min_age, :max_age, :age_unit, :lab_test_id, :animal_type, :description)
    end
  end
end
