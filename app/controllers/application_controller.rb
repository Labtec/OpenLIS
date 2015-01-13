class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_user_language
  before_filter :authenticate_user!
  before_filter :set_active_tab

  def set_user_language
    if current_user
      I18n.locale = current_user.language
    else
      I18n.locale = extract_locale_from_accept_language_header
    end
  end
  helper_method :set_user_language

protected

  def set_active_tab
    @active_tab ||= self.controller_name.to_sym
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  rescue
    I18n.default_locale
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
