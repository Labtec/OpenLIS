# frozen_string_literal: true

module Admin
  class QualifiedIntervalsController < BaseController
    def index
      @lab_tests = LabTest.includes({ qualified_intervals: [:interpretation, :lab_test] }).order(:position)
    end

    def show
      @qualified_interval = QualifiedInterval.find(params[:id])
    end

    def new
      @qualified_interval = QualifiedInterval.new
    end

    def edit
      @qualified_interval = QualifiedInterval.find(params[:id])
    end

    def create
      @qualified_interval = QualifiedInterval.new(qualified_interval_params)
      if @qualified_interval.save
        flash[:notice] = 'Successfully created reference range.'
        redirect_to [:admin, @qualified_interval]
      else
        render action: 'new'
      end
    end

    def update
      @qualified_interval = QualifiedInterval.find(params[:id])
      if @qualified_interval.update(qualified_interval_params)
        flash[:notice] = 'Successfully updated reference range.'
        redirect_to [:admin, @qualified_interval]
      else
        render action: 'edit'
      end
    end

    def destroy
      @qualified_interval = QualifiedInterval.find(params[:id])
      @qualified_interval.destroy
      flash[:notice] = 'Successfully removed reference range.'
      redirect_to admin_qualified_intervals_url
    end

    private

    def qualified_interval_params
      params.require(:qualified_interval).permit(:category, :range_low_value, :range_high_value, :context, :gender, :age_low, :age_high, :gestational_age_low, :gestational_age_high, :condition, :animal_type, :interpretation_id, :lab_test_id)
    end
  end
end
