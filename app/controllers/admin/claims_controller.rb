module Admin
  class ClaimsController < BaseController
    def index
      if params[:insurance_provider_id]
        provider = InsuranceProvider.find(params[:insurance_provider_id])
        @unsubmitted_claims = provider.accessions.includes(:patient, :claim).unclaimed.within_claim_period
        @claims = provider.claims.includes(:patient).submitted.recent
      else
        @unsubmitted_claims = Accession.includes(:patient).with_insurance_provider.unclaimed.within_claim_period
        @claims = Claim.includes(:patient).submitted.recent
      end
    end

    def show
      @claim = Claim.includes(:accession).find(params[:id])

      pdf = ClaimPreview.new(@claim, view_context)
      send_data(pdf.render, filename: "claim_#{@claim.try(:external_number)}.pdf",
                            type: 'application/pdf', disposition: 'inline')
    end

    def new
      @accession = Accession.find(params[:accession_id])
      @claim = @accession.build_claim(insurance_provider: @accession.insurance_provider)
    end

    def create
      @claim = Claim.new(claim_params)
      if @claim.save
        flash[:notice] = 'Successfully created claim.'
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider)
      else
        render action: 'new'
      end
    end

    def edit
      @claim = Claim.find(params[:id])
    end

    def update
      @claim = Claim.find(params[:id])
      if @claim.update_attributes(claim_params)
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
          notice: 'Successfully updated claim.'
      else
        render action: 'edit'
      end
    end

    def submit
      @claim = Claim.find(params[:id])
      if @claim.valid_submission?
        @claim.update_attributes(claimed_at: Time.current)
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
          notice: 'Successfully submitted claim.'
      else
        redirect_to admin_insurance_provider_claims_url(@claim.insurance_provider),
          alert: t('.submit_alert')
      end
    end

    def submit_selected
      if params[:unsubmitted_claim_ids]
        @claims = Claim.find(params[:unsubmitted_claim_ids])
        @claims.each do |claim|
          claim.update_attributes!(claimed_at: Time.current)
        end
        redirect_to admin_claims_url, notice: 'Successfully submitted claims.'
      else
        redirect_to admin_claims_url, alert: 'No claims selected!'
      end
    end

    def print_selected
      if params[:claim_ids]
        @claims = Claim.includes(:accession, :insurance_provider, :patient).find(params[:claim_ids])

        pdf = ClaimsReport.new(@claims, view_context)
        send_data(pdf.render, filename: 'entrada_de_reclamos.pdf',
                              type: 'application/pdf', disposition: 'inline')
      else
        flash[:alert] = 'No claims selected!'
        redirect_to admin_claims_url
      end
    end

    private

    def claim_params
      params.require(:claim).permit(:accession_id, :number, :external_number, :claimed_at, :insurance_provider_id)
    end
  end
end
