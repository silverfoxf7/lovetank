class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  # used to effectuate a redirect to signin if trying to access unauth pages
  # but need an options hash to limit only some pages
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
#    @users = User.all
#  we introduced the paginate method using the 'will_paginate' gem.
#  now instead of User.all, which is an array, we will use the following:

#    @users = User.paginate(:page => params[:page])
    @title = "All Users"
    @user_search = User.search(params[:search])
    @users = @user_search.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
    @jobposts = @user.jobposts.paginate(:page => 1)
    
  end
  
  def following 
    @title = "Following" 
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers" 
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def new
    @user = User.new
    @title = "Sign Up"
  end

  def create
    #raise params[:user].inspect
    
    @user = User.new(params[:user])
    if @user.save
      # handle a successful save.
      UserMailer.registration_confirmation(@user).deliver
      # send an email saying registration successful
      sign_in @user
      
      redirect_to user_path(@user), :flash => { :success => "Welcome to PLE!" }
      
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end
  
  def update
#    @user = User.find(params[:id])
#    got rid of these because the before_filter is running before :edit and :update;
#    thus don't need this assignment.
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
     @title = "Edit User"
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
  
end
