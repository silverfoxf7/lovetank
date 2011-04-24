class MicropostsController < ApplicationController
  
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    # don't use "micropost.new" b/c we want the new micropost to be associated to
    # a particular user.  Here, the user that is logged in is "current_user"
    if @micropost.save 
      redirect_to root_path, :flash => {:success => "Micropost created!"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_to root_path, :flash => { :success => "Micropost deleted." }
  end

  private
  
    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
  
end
