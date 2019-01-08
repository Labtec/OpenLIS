# frozen_string_literal: true

require 'scrypt'

module Devise
  module Encryptor
    def self.digest(klass, password)
      password = "#{password}#{klass.pepper}" if klass.pepper.present?
      ::SCrypt::Password.create(password)
    end

    def self.compare(klass, hashed_password, password)
      return false if hashed_password.blank?

      password = "#{password}#{klass.pepper}" if klass.pepper.present?
      scrypt   = ::SCrypt::Password.new(hashed_password)
      salt     = "#{scrypt.cost}#{scrypt.salt}"
      password = ::SCrypt::Engine.hash_secret(password, salt)
      Devise.secure_compare(password, hashed_password)
    end
  end
end
