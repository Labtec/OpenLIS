class Admin::ReferenceRangesController < Admin::ApplicationController
  def index
    @reference_ranges = ReferenceRange.all(:order => "lab_test_id, age_unit, min_age", :include => :lab_test)
  end
  
  def show
    @reference_range = ReferenceRange.find(params[:id])
  end
  
  def new
    @reference_range = ReferenceRange.new
  end
  
  def create
    @reference_range = ReferenceRange.new(params[:reference_range])
    if @reference_range.save
      flash[:notice] = "Successfully created reference range."
      redirect_to [:admin, @reference_range], :only_path => true
    else
      render :action => 'new'
    end
  end
  
  def edit
    @reference_range = ReferenceRange.find(params[:id])
  end
  
  def update
    @reference_range = ReferenceRange.find(params[:id])
    if @reference_range.update_attributes(params[:reference_range])
      flash[:notice] = "Successfully updated reference range."
      redirect_to [:admin, @reference_range], :only_path => true
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reference_range = ReferenceRange.find(params[:id])
    @reference_range.destroy
    flash[:notice] = "Successfully removed reference range."
    redirect_to admin_reference_ranges_url
  end
end
