# frozen_string_literal: true

class Auth::SessionsController < Devise::SessionsController
  layout 'auth'

  def new
    respond_to do |format|
      format.html do
        super
        expires_now
      end
      format.pdf { redirect_to new_user_session_path }
    end
  end

  def create
    super
    flash[:notice] = t('flash.login.hello') + current_user.first_name + '!' +
                     t('flash.login.last_login_at') +
                     view_context.time_ago_in_words(current_user.last_sign_in_at)
  end
end
