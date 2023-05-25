# frozen_string_literal: true

module Admin
  class QualifiedValuesController < BaseController
    before_action :set_qualified_value, only: %i[edit update destroy]

    def index
      @lab_tests = LabTest.includes({ qualified_values: [:interpretation] }).order(:position)
    end

    def new
      @qualified_value = QualifiedValue.new
    end

    def edit; end

    def create
      @qualified_value = QualifiedValue.new(qualified_value_params)

      if @qualified_value.save
        redirect_to admin_qualified_values_url, notice: 'Successfully created qualified value.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @qualified_value.update(qualified_value_params)
        redirect_to admin_qualified_values_url, notice: 'Successfully updated qualified value.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @qualified_value.destroy

      respond_to do |format|
        format.html { redirect_to admin_qualified_values_url, notice: 'Successfully removed qualified value.' }
        format.turbo_stream { flash.now[:notice] = 'Successfully removed qualified value.' }
      end
    end

    private

    def set_qualified_value
      @qualified_value = QualifiedValue.find(params[:id])
    end

    def qualified_value_params
      params.require(:qualified_value).permit(:range_category, :range_low_value, :range_high_value, :context, :gender, :age_low, :age_high, :gestational_age_low, :gestational_age_high, :condition, :animal_type, :interpretation_id, :lab_test_id)
    end
  end
end
