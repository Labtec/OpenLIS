# frozen_string_literal: true

module Auth
  class SessionsController < Devise::SessionsController
    layout "auth"
    # allow_browser versions: :modern

    include WebauthnConcern

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
      flash[:notice] = t("flash.login.hello") +
                       "#{current_user.first_name}!" +
                       t("flash.login.last_login_at") +
                       view_context.time_ago_in_words(current_user.last_sign_in_at)
    end

    def webauthn_options
      user = find_user

      if user&.webauthn_enabled?
        options_for_get = WebAuthn::Credential.options_for_get(
          allow: user.webauthn_credentials.pluck(:external_id),
          user_verification: "discouraged"
        )

        session[:webauthn_challenge] = options_for_get.challenge

        render json: options_for_get, status: :ok
      else
        render json: { error: t("webauthn_credentials.not_enabled") }, status: :unauthorized
      end
    end

    protected

    def find_user
      if session[:attempt_user_id]
        User.find(session[:attempt_user_id])
      else
        User.find_for_authentication(username: user_params[:username])
      end
    end

    def user_params
      params.expect(user: [
        :username,
        :password,
        credential: {}
      ])
    end

    private

    def restart_session
      clear_attempt_from_session
      redirect_to user_session_path, alert: I18n.t("devise.failure.timeout")
    end

    def set_attempt_session(user)
      session[:attempt_user_id] = user.id
      session[:attempt_user_updated_at] = user.updated_at.to_s
    end

    def clear_attempt_from_session
      session.delete(:attempt_user_id)
      session.delete(:attempt_user_updated_at)
    end
  end
end
