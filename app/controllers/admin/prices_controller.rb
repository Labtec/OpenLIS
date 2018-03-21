# frozen_string_literal: true

module Admin
  class PricesController < BaseController
    def index
      @priceable = find_priceable
      @prices = if @priceable
                  @priceable.prices
                else
                  Price.all
                end

      pdf = LabPriceList.new(@priceable, @prices, view_context)
      send_data(pdf.render, filename: 'lista_de_precios.pdf',
                            type: 'application/pdf', disposition: 'inline')
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
      @price = @priceable.prices.build(price_params)

      if @price.save
        redirect_to(admin_prices_url, notice: 'Price was successfully created.')
      else
        render action: 'new'
      end
    end

    def update
      @price = Price.find(params[:id])

      if @price.update(price_params)
        redirect_to [:admin, @price], notice: 'Price was successfully updated.'
      else
        render action: 'edit'
      end
    end

    def destroy
      @price = Price.find(params[:id])
      @price.destroy

      redirect_to(admin_prices_url)
    end

    protected

    def find_priceable
      params.each do |name, value|
        name =~ /(.+)_id$/
        return Regexp.last_match(1).classify.constantize.find(value) if Regexp.last_match(1)
      end
      nil
    end

    private

    def price_params
      params.require(:price).permit(:price_list_id, :amount)
    end
  end
end
