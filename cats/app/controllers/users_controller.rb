class UsersController < ApplicationController
  before_action :ensure_logged_in

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new, status: 422
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
