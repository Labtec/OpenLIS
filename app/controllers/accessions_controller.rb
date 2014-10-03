class AccessionsController < ApplicationController
  before_filter :set_recent_patients_list, except: [:destroy]

  def index
    if params[:patient_id]
      begin
        @patient = Patient.find(params[:patient_id])
        @pending_accessions = @patient.accessions.queued.pending.paginate(:per_page => 10, :page => params[:pending_page])
        @reported_accessions = @patient.accessions.recently.reported.paginate(:per_page => 10, :page => params[:page])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = t('flash.accession.patient_not_found')
        redirect_to accessions_url
      end
    else
      @pending_accessions = Accession.queued.pending.paginate(:per_page => 10, :page => params[:pending_page])
      @reported_accessions = Accession.recently.reported.paginate(:per_page => 10, :page => params[:page])
    end
  end

  def show
    begin
      @accession = Accession.find(params[:id])
      @results = @accession.results.all(:order => "lab_tests.position", :include => [{:accession => :patient}, {:lab_test => [:department, :unit]}, :lab_test_value]).group_by(&:department)
      @patient = @accession.patient
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('flash.accession.accession_not_found')
      redirect_to accessions_url
    end
  end

  def new
    @patient = Patient.find(params[:patient_id])
    @accession = @patient.accessions.build
    @accession.drawn_at = Time.now
    @accession.drawer_id = current_user.id
    @accession.received_at = Time.now
    @accession.receiver_id = current_user.id
    @departments = Department.all(:order => "lab_tests.position", :include => :lab_tests)
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @accession = @patient.accessions.build(accession_params)
    @departments = Department.all(:order => "lab_tests.position", :include => :lab_tests)
    if @accession.save
      flash[:notice] = t('flash.accession.create')
      redirect_to accession_url(@accession)
    else
      render :action => 'new'
    end
  end

  def edit
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @departments = Department.all(:order => "lab_tests.position", :include => :lab_tests)
    $update_action = 'edit'
  end

  def update
    @accession = Accession.find(params[:id])
    @departments = Department.all(:order => "lab_tests.position", :include => :lab_tests)
    if @accession.update_attributes(accession_params)
      # TODO: This should be by result, not by accession!
      if !@current_user.admin?
        @accession.update_attributes(:reporter_id => current_user.id, :reported_at => Time.now) if @accession.reported_at
      end
      flash[:notice] = t('flash.accession.update')
      redirect_to accession_url(@accession)
    else
      render :action => $update_action
    end
  end

  def destroy
    @accession = Accession.find(params[:id])
    @accession.destroy
    flash[:notice] = t('flash.accession.destroy')
    redirect_to patient_accessions_url(@accession.patient_id)
  end

  def edit_results
    @accession = Accession.find(params[:id], :include => [{:lab_tests => :department}, {:results => :accession}])
    @patient = @accession.patient
    @accession.lab_tests.group_by(&:department).each do |department, lab_tests|
      # Missing per department blank validation. It will only check first
      @accession.notes.build(:department_id => department.id) unless @accession.try(:notes).find_by_department_id(department.id)
    end
    $update_action = 'edit_results'
  end

  def report
    @accession = Accession.find(params[:id])
    if @accession.complete?
      @accession.reporter_id = current_user.id
      @accession.reported_at = Time.now
      @accession.save
      redirect_to accession_results_url(@accession, :format => 'pdf')
    else
      flash[:error] = t('flash.accession.report_error')
      redirect_to accession_url(@accession)
    end
  end

  protected

  def set_recent_patients_list
    @recent ||= Patient.recent
  end

  private

  def accession_params
    params.require(:accession).permit(:drawn_at, :drawer_id, :received_at, :receiver_id, :doctor_name, :icd9, :lab_test_ids, :panel_ids, :result_attributes, :notes_attributes, :reporter_id, :reported_at)
  end
end
