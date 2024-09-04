# frozen_string_literal: true

module Admin
  class PanelsController < BaseController
    before_action :set_panel, only: %i[show edit update destroy]

    def index
      @panels = Panel.all.includes(:lab_tests)
    end

    def show; end

    def new
      @panel = Panel.new
    end

    def edit; end

    def create
      @panel = Panel.new(panel_params)

      if @panel.save
        redirect_to admin_panels_url, notice: "Successfully created panel."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @panel.update(panel_params)
        redirect_to admin_panels_url, notice: "Successfully updated panel."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @panel.destroy

      respond_to do |format|
        format.html { redirect_to admin_panels_url, notice: "Successfully destroyed panel." }
        format.turbo_stream { flash.now[:notice] = "Successfully destroyed panel." }
      end
    end

    private

    def set_panel
      @panel = Panel.find(params[:id])
    end

    def panel_params
      params.require(:panel).permit(:code, :name, :description, :procedure, :loinc, :fasting_status_duration_iso8601, :patient_preparation, :status, lab_test_ids: [])
    end
  end
end
