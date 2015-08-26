module Admin
  class ClaimsController < BaseController
    def index
      if params[:insurance_provider_id]
        provider = InsuranceProvider.find(params[:insurance_provider_id].to_i)
        @unsubmitted_claims = provider.unsubmitted_claims
        @claims = provider.submitted_claims.recent
      else
        @unsubmitted_claims = Accession.find(Accession.within_claim_period.with_insurance_provider.map(&:id) - Claim.submitted.map(&:accession_id))
        @claims = Claim.submitted.recent
      end
    end

    def show
      @claim = Claim.find(params[:id])

      pdf = ClaimPreview.new(@claim, view_context)
      send_data(pdf.render, filename: "claim_#{@claim.try(:external_number)}.pdf",
                type: 'application/pdf', disposition: 'inline')
    end

    def new
      @accession = Accession.find(params[:accession_id])
      @claim = @accession.build_claim(insurance_provider_id: 1)
    end

    def create
      @claim = Claim.new(claim_params)
      if @claim.save
        flash[:notice] = "Successfully created claim."
        redirect_to admin_claims_url
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
        flash[:notice] = "Successfully updated claim."
        respond_to do |format|
          format.html { redirect_to admin_claims_url}
          format.js
        end
      else
        render action: 'edit'
      end
    end

    def submit
      @claim = Claim.find(params[:id])
      if @claim.valid_submission?
        @claim.update_attributes(claimed_at: Time.current, insurance_provider_id: 1)
        redirect_to admin_claims_url, notice: "Successfully submitted claim."
      else
        redirect_to admin_claims_url, alert: t('flash.claim.submit_alert')
      end
    end

    def submit_selected
      if params[:unsubmitted_claim_ids]
        @claims = Claim.find(params[:unsubmitted_claim_ids])
        @claims.each do |claim|
          claim.update_attributes!(claimed_at: Time.current, insurance_provider_id: 1)
        end
        redirect_to admin_claims_url, notice: "Successfully submitted claims."
      else
        redirect_to admin_claims_url, alert: "No claims selected!"
      end
    end

    def print_selected
      if params[:claim_ids]
        @claims = Claim.find(params[:claim_ids]) #, include: {accession: :patient})

        pdf = ClaimsReport.new(@claims, view_context)
        send_data(pdf.render, filename: 'entrada_de_reclamos.pdf',
                  type: 'application/pdf', disposition: 'inline')
      else
        flash[:alert] = "No claims selected!"
        redirect_to admin_claims_url
      end
    end

    private

    def claim_params
      params.require(:claim).permit(:accession_id, :number, :external_number, :claimed_at, :insurance_provider_id)
    end
  end
end
