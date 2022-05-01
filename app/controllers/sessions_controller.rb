class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])  # if user is valid and password is correct
      # Log in the user and redirect to the users show page
      if user.activated?   # log in only if user is activated
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_path
      else 
        message = "Account not activated"
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_path
      end
    else 
      # Create an error message 
      flash.now[:danger] = "Invalid email/password combination" # Not quite right
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?   # only logging out if logged in
    redirect_to root_url
  end
end
