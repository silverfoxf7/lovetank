class FacebookController < ApplicationController
  require 'digest/sha1'
  
  def confirm
    #respond_to do |format|
      if params[:error_reason]
        # The user did not validate, so do something
        flash[:notice] = "You did not successfuly confirm your Facebook account."
	RAILS_DEFAULT_LOGGER.info "Error logging in to FB: " + params[:error_reason]
        redirect_to(signup_url)
      elsif params[:code]
        #The user confirmed. Get the token
        @fb_token = Facebook.getToken(params[:code], facebook_confirm_url)
        RAILS_DEFAULT_LOGGER.info "Received FB Token " + @fb_token
        if(!@fb_token)
          flash[:notice] = "Failed to login through Facebook - no token"
          redirect_to(signin_url)
        end
        
        #Grab the user information
	RAILS_DEFAULT_LOGGER.info "Accessing User Info"
        @fb_user = Facebook.getUserInfo(@fb_token)
	
	#RAILS_DEFAULT_LOGGER.info "FB_USER: ".@fb_user.inspect
        
        #IF this user is logged in to GT, let's connect this account to theirs.
        if(current_user)
          if(current_user.facebook_id == @fb_user["id"].to_s)
            #current_user.facebook_token = @fb_token
            if(current_user.update_attribute(:facebook_token, @fb_token))
		    flash[:notice] = "Updated your Facebook token."
	else
		flash[:notice] = "Could not update your Facebook token."
	end
	
            redirect_to(users_path,  :user => current_user)
          elsif(!current_user.facebook_id)
	    flash[:notice] = "Added your facebook ID"
            #current_user.facebook_id = @fb_user["id"].to_s
            #current_user.facebook_token = @fb_token
		if(!(current_user.update_attribute(:facebook_id, @fb_user["id"].to_s) && current_user.update_attribute(:facebook_token, @fb_token)))
		#if(current_user.save)
			flash[:notice] = "Added your Facebook ID."
		else
			flash[:notice] = "Could not add your Facebook ID."
		end
            redirect_to(users_path,  :user => current_user)
          else
            flash[:notice] = "The Facebook account you're logged in under does not match the one you have on file already."
            redirect_to(users_path,  :user => current_user)
          end
        else
          #If this is a new user, use this token to create the user.
          @user = User.find(:first, :conditions => {:facebook_id => @fb_user["id"].to_s})
          if(!@user)
            @user = User.new
            @user.name = @fb_user["name"].to_s
            #@user.last_name = @fb_user["last_name"].to_s
            @user.facebook_id = @fb_user["id"].to_s
            @user.email = @fb_user["email"].to_s
            @user.password = Digest::SHA1.hexdigest(@fb_user["id"].to_s + Time.now.to_s)
            #@user.password_confirmation = @user.password
            @user.facebook_token = @fb_token
            if(!@user.save)
              flash[:notice] = "Unable to create new account using Facebook"
	      RAILS_DEFAULT_LOGGER.info "Failed to create new user: " + @fb_user.inspect
              redirect_to(signup_url)
            else 
#---> FB Authenticate User Here
              sign_in(@user)
              redirect_to(users_path,  :user => current_user)
            end
          else 
            #@user.facebook_token = @fb_token
            #if(!@user.save)
	    if(!@user.update_attribute(:facebook_token, @fb_token))
              flash[:notice] = "Unable to login using Facebook - could not update"
	      RAILS_DEFAULT_LOGGER.info "Failed to login user: " + @user.inspect
              redirect_to(signin_url)
            else
#---> FB Authenticate User Here
              sign_in(@user)
              redirect_to(users_path,  :user => current_user)
            end
          end
        end
      else 
        # What the? Send them to the signup form
        redirect_to(signin_url)
      end
    #end
  end
end
