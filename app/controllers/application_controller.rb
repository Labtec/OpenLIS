# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # allow_browser versions: :modern
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :unprocessable_entity

  before_action :set_user_language
  before_action :verify_session_ip
  before_action :authenticate_user!, except: :raise_not_found
  before_action :active_tab
  before_action :set_variant
  before_action :store_current_location, except: :raise_not_found, unless: :devise_controller?

  def raise_not_found
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  def set_user_language
    I18n.locale = if current_user
                    current_user.language
    else
                    extract_locale_from_accept_language_header
    end
  rescue StandardError
    I18n.default_locale
  end
  helper_method :set_user_language

  private

  def require_admin!
    redirect_to root_path unless current_user&.admin?
  end

  def verify_session_ip
    return if Rails.env.test?
    return if session[:remote_ip] == request.remote_ip

    reset_session
    session[:remote_ip] = request.remote_ip
  end

  protected

  def active_tab
    @active_tab ||= controller_name.to_sym
  end

  def set_variant
    case request.user_agent
    when /Mobile/i
      request.variant = :mobile
    end
  end

  def extract_locale_from_accept_language_header
    language = request.env["HTTP_ACCEPT_LANGUAGE"].scan(/^[a-z]{2}/).first
    if language == "es"
      "es-PA"
    else
      "en"
    end
  rescue StandardError
    I18n.default_locale
  end

  def store_current_location
    store_location_for(:user, request.url)
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

  def respond_with_error(code)
    respond_to do |format|
      format.any { head code }
      format.html do
        set_user_language
        render file: Rails.public_path.join("#{code}.html"), status: code, layout: false
      end
    end
  end
end
