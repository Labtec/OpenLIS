module UsersHelper
  def current_user_name
    full_name = [current_user.prefix, current_user.first_name, current_user.last_name].join(' ').squish
    if current_user.suffix.blank?
      full_name
    else
      [full_name, current_user.suffix].join(', ').squish
    end
  end

  def current_username
    current_user.username
  end
end
