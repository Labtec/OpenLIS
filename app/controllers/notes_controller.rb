class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      flash[:notice] = "Successfully created note."
      redirect_to @note
    else
      render :action => 'new'
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(note_params)
      flash[:notice] = "Successfully updated note."
      redirect_to @note
    else
      render :action => 'edit'
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    flash[:notice] = "Successfully destroyed note."
    redirect_to notes_url
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
