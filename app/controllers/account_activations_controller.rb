class AccountActivationsController < ApplicationController

    # edit action to activate accounts
    # (also handles the case of an invalid activation token, this should rarely happen
    # but its easy enough to redirect in this case to the root url)
    def edit 
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "Account activated"
            redirect_to user
        else 
            flash[:danger] = "Invalid activation link"
            redirect_to root_path
        end
    end
end
