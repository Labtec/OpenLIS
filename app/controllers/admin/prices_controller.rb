# frozen_string_literal: true

module Admin
  class PricesController < BaseController
    before_action :set_price, only: %i[show edit update destroy]

    def index
      @priceable = find_priceable || PriceList.last
      @prices = @priceable.prices.active

      pdf = LabPriceList.new(@priceable, @prices, view_context)
      send_data(pdf.render, filename: "lista_de_precios.pdf",
                            type: "application/pdf", disposition: "inline")
    end

    def show; end

    def new
      @priceable = find_priceable
      @price = Price.new
    end

    def edit
      @priceable = @price.priceable
    end

    def create
      @priceable = find_priceable
      @price = @priceable.prices.build(price_params)

      if @price.save
        redirect_to polymorphic_url([ :admin, @price.priceable ]), notice: "Price was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      redirect_to admin_lab_tests_url, alert: "Please create a new price list."
      # if @price.update(price_params)
      #   redirect_to polymorphic_url([ :admin, @price.priceable ]), notice: "Price was successfully updated."
      # else
      #   render :edit, status: :unprocessable_content
      # end
    end

    def destroy
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

    def set_price
      @price = Price.find(params[:id])
    end

    def price_params
      params.expect(price: [
        :price_list_id,
        :amount
      ])
    end
  end
end
