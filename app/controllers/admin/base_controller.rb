module Admin
  class BaseController < ApplicationController
    layout 'admin/application'
    before_action :require_admin_user

    private

    def require_admin_user
      if current_user && !current_user.admin?
        flash[:notice] = 'You must be Administrator to access this page.'
        redirect_to root_path
        false
      end
    end
  end
end
