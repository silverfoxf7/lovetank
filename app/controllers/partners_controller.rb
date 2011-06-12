class PartnersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  # used to effectuate a redirect to signin if trying to access unauth pages
  # but need an options hash to limit only some pages
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
  end

  def show
  end

  def new
    @user = User.new
    @title = "Enter Your Partner's Information"
  end

  def create
    @user = User.new(params[:user])
    new_random_password

    if @user.save
        # build relationship here
        current_user.follow!(@user)
        @user.follow!(current_user)
        redirect_to user_path(current_user), :flash => { :success => "Thank you for adding your partner!" }
    else
      @title = "Enter Your Partner's Information"
      render 'new'
    end    
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit Your Partner"
  end
  
  def update
#    @user = User.find(params[:id])
#    got rid of these because the before_filter is running before :edit and :update;
#    thus don't need this assignment.
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
     @title = "Edit Partner"
     render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, :flash => {:success => "User destroyed."}
  end
  
#---------------------------------
  private
    # def authenticate
    #   deny_access unless signed_in?
    #   # deny_access is located in the sessions_helper for refactoring purposes
    # end
    
    # After Chapter 11 we moved this authenticate method to the Sessions helper so it could be used
    # by the microposts_controller.rb
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      # unless @user == current_user is very common.  we'll define as method current_user?(@user)
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
    end

    def new_random_password
#      @temppass = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{current_user.name}--")[0,6]
      @temppass = "foobar"
      @user.password = @temppass
      @user.password_confirmation = @temppass
    end

end
