class SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  skip_before_filter :verify_authenticity_token, only: :destroy

  # GET /resource/sign_in
  def new
    respond_to do |format|
      format.html do
        super
        expires_now
      end
      format.pdf { redirect_to new_user_session_path }
    end
  end

  # POST /resource/sign_in
  def create
    super
    flash[:notice] = t('flash.login.hello') + current_user.first_name + '!' +
      t('flash.login.last_login_at') +
      view_context.distance_of_time_in_words(current_user.last_sign_in_at,
                                             Time.now)
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
