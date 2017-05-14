class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :unprocessable_entity

  before_action :set_user_language
  before_action :authenticate_user!
  before_action :set_active_tab
  before_action :set_variant

  def set_user_language
    if current_user
      I18n.locale = current_user.language
    else
      I18n.locale = extract_locale_from_accept_language_header
    end
  rescue
    I18n.default_locale
  end
  helper_method :set_user_language

  protected

  def set_active_tab
    @active_tab ||= controller_name.to_sym
  end

  def set_variant
    case request.user_agent
    when /Mobile/i
      request.variant = :mobile
    end
  end

  def extract_locale_from_accept_language_header
    language = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if language == 'es'
      'es-PA'
    else
      'en'
    end
  rescue
    I18n.default_locale
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def not_found
    respond_with_error(404)
  end

  def unprocessable_entity
    respond_with_error(422)
  end
end
