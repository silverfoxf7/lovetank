class LoveactionsController < ApplicationController
  
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def create
    @loveaction = current_user.loveactions.build(params[:loveaction])
    # don't use "loveaction.new" b/c we want the new loveaction to be associated to
    # a particular user.  Here, the user that is logged in is "current_user"
    if @loveaction.save
      redirect_to current_user, :flash => {:success => "Love Action Created!"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @loveaction.destroy
    redirect_to root_path, :flash => { :success => "Love Action Deleted." }
  end

  private
  
    def authorized_user
      @loveaction = loveaction.find(params[:id])
      redirect_to root_path unless current_user?(@loveaction.user)
    end
  
end
