# frozen_string_literal: true

WebAuthn.configure do |config|
  config.origin = ENV.fetch("WEBAUTHN_ORIGIN", nil)
  config.rp_name = "OpenLIS"
end
