# frozen_string_literal: true

module Settings
  class WebauthnCredentialsController < ApplicationController
    before_action :require_webauthn_enabled, only: :destroy

    def new
      @webauthn_credential = WebauthnCredential.new
    end

    def options
      current_user.update(webauthn_id: WebAuthn.generate_user_id) unless current_user.webauthn_id

      options_for_create = WebAuthn::Credential.options_for_create(
        user: {
          name: current_user.username,
          id: current_user.webauthn_id,
          display_name: helpers.current_user_name
        },
        exclude: current_user.webauthn_credentials.pluck(:external_id)
      )

      session[:webauthn_challenge] = options_for_create.challenge

      render json: options_for_create, status: :ok
    end

    def create
      webauthn_credential = WebAuthn::Credential.from_create(params[:credential])

      if webauthn_credential.verify(session[:webauthn_challenge])
        user_credential = current_user.webauthn_credentials.build(
          external_id: webauthn_credential.id,
          public_key: webauthn_credential.public_key,
          nickname: params[:nickname],
          sign_count: webauthn_credential.sign_count
        )

        if user_credential.save
          flash[:notice] = t('.success')
          status = :ok
        else
          flash[:alert] = t('.error')
          status = :internal_server_error
        end
      else
        flash[:alert] = t('.error')
        status = :unauthorized
      end

      render json: { redirect_path: profile_path }, status: status
    end

    def destroy
      @credential = current_user.webauthn_credentials.find_by(id: params[:id])
      respond_to do |format|
        if @credential
          if current_user.last_security_key?
            format.html { flash[:alert] = t('flash.users.cant_delete_last_security_key') }
            format.turbo_stream { flash.now[:alert] = t('flash.users.cant_delete_last_security_key') }
          else
            @credential.destroy
            if @credential.destroyed?
              format.html { flash[:notice] = t('.success') }
              format.turbo_stream { flash.now[:notice] = t('.success') }
            else
              format.html { flash[:alert] = t('.error') }
              format.turbo_stream { flash.now[:alert] = t('.error') }
            end
          end
        else
          format.html { flash[:alert] = t('.error') }
          format.turbo_stream { flash.now[:alert] = t('.error') }
        end
        format.html { redirect_to profile_url }
      end
    end

    private

    def require_webauthn_enabled
      return if current_user.webauthn_enabled?

      flash[:alert] = t('.not_enabled')
      redirect_to profile_url
    end
  end
end
