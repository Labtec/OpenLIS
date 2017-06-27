# frozen_string_literal: true

module Admin
  class PanelsController < BaseController
    def index
      @panels = Panel.all
    end

    def show
      @panel = Panel.find(params[:id])
    end

    def new
      @panel = Panel.new
    end

    def create
      @panel = Panel.new(panel_params)
      if @panel.save
        flash[:notice] = 'Successfully created panel.'
        redirect_to [:admin, @panel]
      else
        render action: 'new'
      end
    end

    def edit
      @panel = Panel.find(params[:id])
    end

    def update
      @panel = Panel.find(params[:id])
      if @panel.update_attributes(panel_params)
        flash[:notice] = 'Successfully updated panel.'
        redirect_to [:admin, @panel]
      else
        render action: 'edit'
      end
    end

    def destroy
      @panel = Panel.find(params[:id])
      @panel.destroy
      flash[:notice] = 'Successfully destroyed panel.'
      redirect_to admin_panels_url
    end

    private

    def panel_params
      params.require(:panel).permit(:code, :name, :description, :procedure, lab_test_ids: [])
    end
  end
end
