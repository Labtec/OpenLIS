# frozen_string_literal: true

module Admin
  class ClaimsController < BaseController
    before_action :set_claim, only: %i[show edit update submit]

    def index
      if params[:insurance_provider_id]
        provider = InsuranceProvider.find(params[:insurance_provider_id])
        @unsubmitted_claims = provider.accessions.includes(:patient, :claim).claimable.unclaimed.within_claim_period
        @claims = provider.claims.includes(:patient).submitted.recent
      else
        @unsubmitted_claims = Accession.includes(:patient).with_insurance_provider.claimable.unclaimed.within_claim_period
        @claims = Claim.includes(:patient).submitted.recent
      end
    end

    def show
      pdf = ClaimPreview.new(@claim, view_context)
      send_data(pdf.render, filename: "claim_#{@claim.try(:external_number)}.pdf",
                            type: 'application/pdf', disposition: 'inline')
    end

    def new
      @accession = Accession.find(params[:accession_id])
      @claim = @accession.build_claim(insurance_provider: @accession.insurance_provider)
    end

    def edit; end

    def create
      @claim = Claim.new(claim_params)

      if @claim.save
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
                    notice: 'Successfully created claim.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @claim.update(claim_params)
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
                    notice: 'Successfully updated claim.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def submit
      if @claim.valid_submission?
        @claim.update(claimed_at: Time.current)
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
                    notice: 'Successfully submitted claim.'
      else
        render :index, alert: t('.submit_alert'), status: :unprocessable_entity
      end
    end

    def submit_selected
      if params[:unsubmitted_claim_ids]
        @claims = Claim.find(params[:unsubmitted_claim_ids])
        @claims.each do |claim|
          if claim.valid_submission?
            claim.update!(claimed_at: Time.current)
            flash[:notice] = 'Claims successfully submitted.'
          else
            flash[:alert] = 'Some claims were not submitted.'
          end
        end
        redirect_to admin_claims_url
      else
        redirect_to admin_claims_url, alert: 'No claims selected!'
      end
    end

    def process_selected
      if params[:claim_ids]
        @claims = Claim.includes(:accession, :insurance_provider, :patient).find(params[:claim_ids])

        if params['print']
          pdf = ClaimsReport.new(@claims, view_context)
          send_data(pdf.render, filename: 'entrada_de_reclamos.pdf',
                                type: 'application/pdf', disposition: 'inline')
        elsif params['invoice']
          invoice = Invoice.new(@claims)
          send_data(invoice.csv, filename: 'plantilla_factura.csv', type: 'text/csv')
        end
      else
        redirect_to admin_claims_url, alert: 'No claims selected!'
      end
    end

    private

    def set_claim
      @claim = Claim.find(params[:id])
    end

    def claim_params
      params.require(:claim).permit(:accession_id, :number, :external_number, :claimed_at, :insurance_provider_id)
    end
  end
end
