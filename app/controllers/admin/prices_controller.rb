class Admin::PricesController < Admin::ApplicationController
  def index
    @priceable = find_priceable
    if @priceable
      @prices = @priceable.prices(:include => [:price_list, :priceable])
    else
      @prices = Price.all(:include => [:price_list, :priceable])
    end
  end

  def show
    @price = Price.find(params[:id])
  end

  def new
    @priceable = find_priceable
    @price = Price.new
  end

  def edit
    @price = Price.find(params[:id])
    @priceable = @price.priceable
  end

  def create
    @priceable = find_priceable
    @price = @priceable.prices.build(params[:price])

    if @price.save
      redirect_to(admin_prices_url, :notice => 'Price was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @price = Price.find(params[:id])

    if @price.update_attributes(params[:price])
      redirect_to [:admin, @price], :notice => 'Price was successfully updated.', :only_path => true
    else
      render :action => "edit"
    end
  end

  def destroy
    @price = Price.find(params[:id])
    @price.destroy

    redirect_to(admin_prices_url)
  end

private

  def find_priceable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
