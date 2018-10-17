class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :current_user

  def log_in!(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def log_out!
    current_user.reset_session_token! unless current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def ensure_logged_in
    redirect_to cats_url if logged_in?
  end

  def logged_in?
    !!current_user
  end

end
