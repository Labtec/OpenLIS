class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery with: :exception

  before_filter :set_user_language
  before_filter :set_active_tab

  helper_method :current_user_session, :current_user

protected

  def set_active_tab
    @active_tab ||= self.controller_name.to_sym
  end

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to logout_url
      return false
    end
  end

  def store_location
    session[:return_to] =
    if request.get?
      request.request_uri
    else
      request.referer
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_user_language
    if current_user
      I18n.locale = current_user.language
    else
      I18n.locale = "es"
    end
  end
end
