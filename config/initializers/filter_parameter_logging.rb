# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:address,
                                               :animal_type,
                                               :birthdate,
                                               :email,
                                               :family_name,
                                               :family_name2,
                                               :given_name,
                                               :identifier,
                                               :insurance_provider_id,
                                               :middle_name,
                                               :password,
                                               :password_confirmation,
                                               :phone,
                                               :search]
