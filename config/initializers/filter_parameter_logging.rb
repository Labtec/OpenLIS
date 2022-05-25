# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :address,
  :animal_type,
  :birthdate,
  :cellular,
  :deceased,
  :email,
  :family_name,
  :family_name2,
  :gender,
  :given_name,
  :identifier,
  :identifier_type,
  :insurance_provider_id,
  :middle_name,
  :partner_name,
  :password,
  :phone,
  :policy_number,
  :search
]
