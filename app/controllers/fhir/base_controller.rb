# frozen_string_literal: true

module FHIR
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate
    rate_limit to: 5, within: 10.minutes

    private

    def authenticate
      authenticate_or_request_with_http_token do |token, _options|
        ActiveSupport::SecurityUtils.secure_compare(token, Rails.application.credentials.dig(:lab_connect, :pat))
      end
    end
  end
end
