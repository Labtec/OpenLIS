# frozen_string_literal: true

class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:notice] = 'Successfully updated profile.'
      redirect_to root_url
    else
      render action: 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :initials, :language, :first_name, :last_name, :prefix, :suffix, :register)
  end
end
