class Admin::ApplicationController < ApplicationController
  layout "admin/application"
  before_filter :require_admin_user

  prawnto :prawn => {
    :info => {
      :Author => "MasterLab",
      :Subject => "",
      :Creator => "MasterLab",
      :Producer => "MasterLab",
      :CreationDate => Time.now
    },
    :compress => true,
    :optimize_objects => true
  }

  private

  def require_admin_user
    require_user
    if @current_user && !@current_user.admin?
      flash[:notice] = "You must be Administrator to access this page."
      redirect_to root_path
      false
    end
  end
end