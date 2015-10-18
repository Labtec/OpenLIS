class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :registerable,
  # :rememberable and :omniauthable
  devise :database_authenticatable, :lockable, :timeoutable,
         :trackable, :validatable

  has_many :accessions, inverse_of: :user

  validates :first_name, :last_name, :initials, presence: true
  validates :initials, uniqueness: true

  def name_to_display
    full_name = [prefix, first_name, last_name].join(' ').squeeze(' ').strip
    if suffix.blank?
      full_name
    else
      [full_name, suffix].join(', ')
    end
  end
end
