# frozen_string_literal: true

class WellKnownController < ActionController::Base
  before_action :authenticate_user!, only: :change_password

  def change_password
    redirect_to profile_url, status: :temporary_redirect
  end

  def jwks
    response.set_header('access-control-allow-origin', '*')
    render json: key_set.to_jwk
  end

  private

  def key_set
    key = Rails.application.config.hc_key.public_key
    HealthCards::KeySet.new(key)
  end
end
