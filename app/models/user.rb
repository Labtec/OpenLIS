class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :registerable,
  # :rememberable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :trackable, :validatable

  has_many :accessions, inverse_of: :user

  validates :first_name, :last_name, :initials, presence: true
  validates :initials, uniqueness: true
end
