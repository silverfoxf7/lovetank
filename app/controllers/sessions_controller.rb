class SessionsController < ApplicationController
  def new
    @title = "Sign In"
  end
  
  def create
    
    # now need to "authenticate" the submitted information
    user = User.authenticate(params[:session][:email], 
                             params[:session][:password])
    if user.nil? 
      flash.now[:error] = "Invalid email/password combination."
      # flash.now is special; it lasts for one "request"
      @title = "Sign In"
      render 'new'  # allows me to re-render the "new" page after a failed submit
    else
      # Handle successful signin.
      sign_in user
      redirect_back_or user
    end
    
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
