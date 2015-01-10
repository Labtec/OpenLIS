class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_user_language
  before_filter :authenticate_user!
  before_filter :set_active_tab

protected

  def set_active_tab
    @active_tab ||= self.controller_name.to_sym
  end

  def set_user_language
    if current_user
      I18n.locale = current_user.language
    else
      I18n.locale = "es"
    end
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
