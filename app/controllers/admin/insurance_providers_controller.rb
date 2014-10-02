class Admin::InsuranceProvidersController < Admin::ApplicationController
  def index
    @insurance_providers = InsuranceProvider.all
  end
  
  def show
    @insurance_provider = InsuranceProvider.find(params[:id])
  end
  
  def new
    @insurance_provider = InsuranceProvider.new
  end
  
  def create
    @insurance_provider = InsuranceProvider.new(params[:insurance_provider])
    if @insurance_provider.save
      flash[:notice] = "Successfully created insurance provider."
      redirect_to [:admin, @insurance_provider], :only_path => true
    else
      render :action => 'new'
    end
  end
  
  def edit
    @insurance_provider = InsuranceProvider.find(params[:id])
  end
  
  def update
    @insurance_provider = InsuranceProvider.find(params[:id])
    if @insurance_provider.update_attributes(params[:insurance_provider])
      flash[:notice] = "Successfully updated insurance provider."
      redirect_to [:admin, @insurance_provider], :only_path => true
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @insurance_provider = InsuranceProvider.find(params[:id])
    @insurance_provider.destroy
    flash[:notice] = "Successfully destroyed insurance provider."
    redirect_to admin_insurance_providers_url
  end
end
