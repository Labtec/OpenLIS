class UserSession < Authlogic::Session::Base
  include ActiveModel::Naming

  logout_on_timeout Rails.env.production?

  def parents
    []
  end

  def name
    'UserSession'
  end
end
