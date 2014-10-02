# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :password_confirmation, :given_name, :middle_name, :family_name, :family_name2, :birthdate, :identifier, :email, :phone, :address, :animal_type, :insurance_provider_id, :search]
