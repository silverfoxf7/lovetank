class LoveactionsController < ApplicationController
  
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy
  
  def create
    @loveaction = current_user.loveactions.build(params[:loveaction])

    @temp = Relationship.find_by_follower_id(current_user)
    @partner = User.find(@temp.followed_id)

    @loveaction.recip_id = @partner.id
      
    if @loveaction.save
      redirect_to current_user, :flash => {:success => "Love Action Posted!"}
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
