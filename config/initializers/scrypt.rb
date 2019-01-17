# frozen_string_literal: true

require 'bcrypt'
require 'scrypt'

module Devise
  module Encryptor
    def self.digest(klass, password)
      password = "#{password}#{klass.pepper}" if klass.pepper.present?
      ::SCrypt::Password.create(password)
    end

    def self.compare(klass, hashed_password, password)
      return false if hashed_password.blank?

      original_password = password
      password = "#{password}#{klass.pepper}" if klass.pepper.present?

      if hashed_password.start_with?('$2a$')
        bcrypt   = ::BCrypt::Password.new(hashed_password)
        password = ::BCrypt::Engine.hash_secret(password, bcrypt.salt)
        if Devise.secure_compare(password, hashed_password)
          User.find_by(encrypted_password: hashed_password)
              .update!(encrypted_password: digest(klass, original_password))
          return true
        end
      end

      scrypt   = ::SCrypt::Password.new(hashed_password)
      salt     = "#{scrypt.cost}#{scrypt.salt}"
      password = ::SCrypt::Engine.hash_secret(password, salt)
      Devise.secure_compare(password, hashed_password)
    end
  end
end
