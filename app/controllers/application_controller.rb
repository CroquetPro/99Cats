class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    session[:session_token] = user.reset_session_token!
    # session[:user_id] = @current_user.id
    redirect_to cats_url
  end
end
