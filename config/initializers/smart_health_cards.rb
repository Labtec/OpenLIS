# frozen_string_literal: true

Rails.application.configure do
  config.hc_key_path = ENV.fetch("HEALTH_CARDS_KEY_PATH", "config/keys/health_cards.pem")
  FileUtils.mkdir_p(File.dirname(config.hc_key_path))
  kp = HealthCards::PrivateKey.load_from_or_create_from_file(config.hc_key_path)

  config.hc_key = kp
  config.issuer = HealthCards::Issuer.new(url: ENV.fetch("HEALTH_CARDS_HOST", "http://localhost:3000"),
                                          key: config.hc_key)
end
