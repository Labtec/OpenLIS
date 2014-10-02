class User < ActiveRecord::Base
  # Consider caching this model
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  has_many :accessions

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
