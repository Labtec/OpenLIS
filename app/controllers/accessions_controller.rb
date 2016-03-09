class AccessionsController < ApplicationController
  before_action :set_recent_patients_list, except: [:destroy]

  def index
    @pending_accessions = Accession.includes(:drawer, :patient, results: [:lab_test, :lab_test_value]).queued.pending.page(params[:pending_page])
    @reported_accessions = Accession.includes(:patient, :reporter).recently.reported.page(params[:page])
  end

  def show
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @results = @accession.results.includes({ accession: { notes: [:department] } }, { lab_test: [:department] }, :lab_test_value, :reference_ranges, :unit).order('lab_tests.position').group_by(&:department)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('flash.accession.accession_not_found')
    redirect_to accessions_url
  end

  def new
    @patient = Patient.find(params[:patient_id])
    @accession = @patient.accessions.build
    @accession.drawn_at = Time.current
    @accession.drawer_id = current_user.id
    @accession.received_at = Time.current
    @accession.receiver_id = current_user.id
    @panels = Panel.sorted.includes(:lab_tests)
    @departments = Department.all.includes(:lab_tests)
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @panels = Panel.sorted.includes(:lab_tests)
    @departments = Department.all.includes(:lab_tests)
    @accession = @patient.accessions.build(accession_params)
    if @accession.save
      flash[:notice] = t('flash.accession.create')
      redirect_to accession_url(@accession)
    else
      render action: 'new'
    end
  end

  def edit
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @departments = Department.all.includes(:lab_tests)
    @panels = Panel.sorted.includes(:lab_tests)
    $update_action = 'edit'
  end

  def update
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @departments = Department.all.includes(:lab_tests)
    @panels = Panel.sorted.includes(:lab_tests)
    if @accession.update(accession_params)
      unless current_user.admin?
        @accession.update(reporter_id: current_user.id, reported_at: Time.current) if @accession.reported_at
      end
      flash[:notice] = t('flash.accession.update')
      redirect_to accession_url(@accession)
    else
      render action: $update_action
    end
  end

  def destroy
    @accession = Accession.find(params[:id])
    @accession.destroy
    flash[:notice] = t('flash.accession.destroy')
    redirect_to patient_url(@accession.patient_id)
  end

  def edit_results
    @accession = Accession.find(params[:id])
    @patient = @accession.patient
    @results = @accession.results.includes({ accession: { notes: [:department] } }, { lab_test: [:department] }, :lab_test_value, :reference_ranges, :unit).order('lab_tests.position').group_by(&:department)
    # TODO: Missing per department blank validation.
    # It will only check first
    @results.each do |department, _result|
      @accession.notes.build(department_id: department.id) unless @accession.try(:notes).find_by_department_id(department.id)
    end
    $update_action = 'edit_results'
  end

  def report
    @accession = Accession.find(params[:id])
    if @accession.complete?
      @accession.reporter_id = current_user.id
      @accession.reported_at = Time.current
      @accession.save
      redirect_to accession_results_url(@accession, format: 'pdf')
    else
      flash[:error] = t('flash.accession.report_error')
      redirect_to accession_url(@accession)
    end
  end

  protected

  def set_recent_patients_list
    @recent ||= Patient.cached_recent
  end

  private

  def accession_params
    params.require(:accession).permit(:drawn_at, :drawer_id, :received_at, :receiver_id, :doctor_name, :icd9, { lab_test_ids: [] }, :reporter_id, :reported_at, { results_attributes: [:id, :lab_test_id, :lab_test_value_id, :value] }, { panel_ids: [] }, { notes_attributes: [:id, :content, :department_id] })
  end
end
