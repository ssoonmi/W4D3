class SessionsController < ApplicationController
  before_action :ensure_logged_in, only: [:new, :create]
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if user
      log_in!(user)
      redirect_to cats_url
    else
      flash[:errors] = ['Invalid username or password']
      redirect_to new_session_url
    end
  end

  def destroy
    log_out!
  end
end
