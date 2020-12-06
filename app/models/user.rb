# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :registerable,
  # :rememberable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :trackable, :validatable

  has_many :accessions, dependent: :nullify
  has_many :webauthn_credentials, dependent: :destroy

  validates :username, :first_name, :last_name, :initials, presence: true
  validates :initials, uniqueness: true

  scope :sorted, -> { order(username: :asc) }

  auto_strip_attributes :username, :initials, delete_whitespaces: true
  auto_strip_attributes :first_name, :last_name

  def webauthn_enabled?
    webauthn_credentials.any?
  end

  def last_security_key?
    webauthn_credentials.size == 1
  end
end
