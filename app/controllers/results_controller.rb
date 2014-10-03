class ResultsController < ApplicationController
  def index
    @accession = Accession.find(params[:accession_id])
    @results = @accession.results.all(:order => "lab_tests.position", :include => [{:accession => :patient}, {:lab_test => [:department, :unit]}, :lab_test_value]).group_by(&:department)
    #@results = @accession.results.all(:order => "lab_tests.position", :include => [:lab_test, :accession, :lab_test_value]).group_by(&:department)
    prawnto :prawn => {
      :info => {
        :Title => "Reporte de Resultados",
        :Author => "MasterLab—Laboratorio Clínico Especializado",
        :Subject => "Accesión #{@accession.id}",
        :Producer => "MasterLab",
        :Creator => "MasterLab",
        :CreationDate => @accession.drawn_at,
        :ModDate => @accession.reported_at,
        :Keywords => "prueba laboratorio reporte resultado #{@accession.id}"
      },
      :inline => true,
      # Letter (8.5 x 11 in) is 612 x 792
      :top_margin => 60,
      # :right_margin => 36, # 0.5 in
      :bottom_margin => 71,
      # :left_margin => 36, # 0.5 in
      :compress => true,
      :optimize_objects => true,
      :print_scaling => :none
    }
  end
    
  def new
    @result = @accession.results.new
  end
  
  def create
    @result = @accession.results.new(params[:result])
    if @result.save
      flash[:notice] = "Successfully created result."
      redirect_to [@accession, @result], :only_path => true
    else
      render :action => 'new'
    end
  end
  
  def edit
    @accession = Accession.find(params[:accession_id])
    #@result = @accession.results.find(params[:id])
  end
  
  def update
    @result = @accession.results.find(params[:id])
    if @result.update_attributes(params[:result])
      flash[:notice] = "Successfully updated result."
      redirect_to [@accession, @result], :only_path => true
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @result = @accession.results.find(params[:id])
    @result.destroy
    flash[:notice] = "Successfully destroyed result."
    redirect_to accession_results_url
  end
end
