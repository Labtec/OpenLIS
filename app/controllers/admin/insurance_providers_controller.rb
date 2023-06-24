# frozen_string_literal: true

module Admin
  class InsuranceProvidersController < BaseController
    before_action :set_insurance_provider, only: %i[show edit update destroy]

    def index
      @insurance_providers = InsuranceProvider.all
    end

    def show; end

    def new
      @insurance_provider = InsuranceProvider.new
    end

    def edit; end

    def create
      @insurance_provider = InsuranceProvider.new(insurance_provider_params)

      if @insurance_provider.save
        redirect_to admin_insurance_providers_url, notice: 'Successfully created insurance provider.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @insurance_provider.update(insurance_provider_params)
        redirect_to admin_insurance_providers_url, notice: 'Successfully updated insurance provider.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @insurance_provider.destroy

      respond_to do |format|
        format.html { redirect_to admin_insurance_providers_url, notice: 'Successfully destroyed insurance provider.' }
        format.turbo_stream { flash.now[:notice] = 'Successfully destroyed insurance provider.' }
      end
    end

    private

    def set_insurance_provider
      @insurance_provider = InsuranceProvider.find(params[:id])
    end

    def insurance_provider_params
      params.require(:insurance_provider).permit(:name, :price_list_id)
    end
  end
end
