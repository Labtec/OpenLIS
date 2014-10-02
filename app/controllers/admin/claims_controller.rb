class Admin::ClaimsController < Admin::ApplicationController
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
    respond_to do |format|
      format.pdf { render :layout => false }
    end
  end

  def new
    @accession = Accession.find(params[:accession_id])
    @claim = @accession.build_claim(:insurance_provider_id => 1)
  end

  def create
    @claim = Claim.new(params[:claim])
    if @claim.save
      flash[:notice] = "Successfully created claim."
      redirect_to admin_claims_url
    else
      render :action => 'new'
    end
  end

  def edit
    @claim = Claim.find(params[:id])
  end

  def update
    @claim = Claim.find(params[:id])
    if @claim.update_attributes(params[:claim])
      flash[:notice] = "Successfully updated claim."
      respond_to do |format|
        format.html { redirect_to admin_claims_url}
        format.js
      end
    else
      render :action => 'edit'
    end
  end

  def submit
    @claim = Claim.find(params[:id])
    if @claim.valid_submission?
      @claim.update_attributes(:claimed_at => Time.now, :insurance_provider_id => 1)
      redirect_to admin_claims_url, :notice => "Successfully submitted claim."
    else
      redirect_to admin_claims_url, :alert => t('flash.claim.submit_alert')
    end
  end

  def submit_selected
    if params[:unsubmitted_claim_ids]
      @claims = Claim.find(params[:unsubmitted_claim_ids])
      @claims.each do |claim|
        claim.update_attributes!(:claimed_at => Time.now, :insurance_provider_id => 1)
      end
      redirect_to admin_claims_url, :notice => "Successfully submitted claims."
    else
      redirect_to admin_claims_url, :alert => "No claims selected!"
    end
  end

  def print_selected
    if params[:claim_ids]
      @claims = Claim.find(params[:claim_ids], :include => {:accession => :patient})
      render :action => 'index.pdf', :layout => false
    else
      flash[:alert] = "No claims selected!"
      redirect_to admin_claims_url
    end
  end
end