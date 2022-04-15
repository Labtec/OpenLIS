# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += [
  :address,
  :animal_type,
  :birthdate,
  :cellular,
  :deceased,
  :email,
  :family_name,
  :family_name2,
  :given_name,
  :identifier,
  :identifier_type,
  :insurance_provider_id,
  :middle_name,
  :phone,
  :search,
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
