class Admin::UnitsController < Admin::ApplicationController
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
    @unit = Unit.new(params[:unit])
    if @unit.save
      flash[:notice] = "Successfully created unit."
      redirect_to [:admin, @unit], :only_path => true
    else
      render :action => 'new'
    end
  end
  
  def edit
    @unit = Unit.find(params[:id])
  end
  
  def update
    @unit = Unit.find(params[:id])
    if @unit.update_attributes(params[:unit])
      flash[:notice] = "Successfully updated unit."
      redirect_to [:admin, @unit], :only_path => true
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    flash[:notice] = "Successfully destroyed unit."
    redirect_to admin_units_url
  end
end
