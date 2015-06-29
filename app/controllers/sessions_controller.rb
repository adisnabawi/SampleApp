class SessionsController < ApplicationController
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  
  def current_registered_user
    user == current_user
  end
  
  def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
  # Log the user in and redirect to the user's show page.
  log_in user
  params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  redirect_to user
  else
  # Create an error message.
  flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
  render 'new'
  end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
end
