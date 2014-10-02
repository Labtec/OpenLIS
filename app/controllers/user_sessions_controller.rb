class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Hola " << @user_session.user.first_name << "!"
      if @user_session.user.login_count > 1
        flash[:notice] << t('flash.login.last_login_at') << l(@user_session.user.last_login_at, :format => t('flash.login.last_login_at_format'))
      end
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def destroy
    @user_session = current_user_session
    @user_session.destroy if @user_session
    reset_session
    redirect_to login_url
  end
end
