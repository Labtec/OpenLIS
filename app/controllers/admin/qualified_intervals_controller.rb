# frozen_string_literal: true

module Admin
  class QualifiedIntervalsController < BaseController
    before_action :set_qualified_interval, only: %i[edit update destroy]

    def index
      @lab_tests = LabTest.includes({ qualified_intervals: [ :interpretation ] }).order(:position)
    end

    def new
      @qualified_interval = QualifiedInterval.new
    end

    def edit; end

    def create
      @qualified_interval = QualifiedInterval.new(qualified_interval_params)

      if @qualified_interval.save
        redirect_to admin_qualified_intervals_url, notice: "Successfully created qualified interval."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @qualified_interval.update(qualified_interval_params)
        redirect_to admin_qualified_intervals_url, notice: "Successfully updated qualified interval."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @qualified_interval.destroy

      respond_to do |format|
        format.html { redirect_to admin_qualified_intervals_url, notice: "Successfully removed qualified interval." }
        format.turbo_stream { flash.now[:notice] = "Successfully removed qualified interval." }
      end
    end

    private

    def set_qualified_interval
      @qualified_interval = QualifiedInterval.find(params[:id])
    end

    def qualified_interval_params
      params.permit(qualified_interval: [
        :category,
        :range_low_value,
        :range_high_value,
        :context,
        :gender,
        :age_low,
        :age_high,
        :gestational_age_low,
        :gestational_age_high,
        :condition,
        :animal_type,
        :interpretation_id,
        :lab_test_id
      ]).require(:qualified_interval)
    end
  end
end
