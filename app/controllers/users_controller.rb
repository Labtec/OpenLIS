# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to root_url, notice: "Successfully updated profile."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :initials, :language, :first_name, :last_name, :prefix, :suffix, :register)
  end
end
