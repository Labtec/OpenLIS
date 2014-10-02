class Admin::LabTestValuesController < Admin::ApplicationController
  def index
    @lab_test_values = LabTestValue.all(:order => "value ASC")
  end
  
  def show
    @lab_test_value = LabTestValue.find(params[:id])
  end
  
  def new
    @lab_test_value = LabTestValue.new
  end
  
  def create
    @lab_test_value = LabTestValue.new(params[:lab_test_value])
    if @lab_test_value.save
      flash[:notice] = "Successfully created lab test value."
      redirect_to [:admin, @lab_test_value], :only_path => true
    else
      render :action => 'new'
    end
  end
  
  def edit
    @lab_test_value = LabTestValue.find(params[:id])
  end
  
  def update
    @lab_test_value = LabTestValue.find(params[:id])
    if @lab_test_value.update_attributes(params[:lab_test_value])
      flash[:notice] = "Successfully updated lab test value."
      redirect_to [:admin, @lab_test_value], :only_path => true
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @lab_test_value = LabTestValue.find(params[:id])
    @lab_test_value.destroy
    flash[:notice] = "Successfully destroyed lab test value."
    redirect_to admin_lab_test_values_url
  end
end
