class PagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @jobpost = Jobpost.new if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
      @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
    end
  end
  
  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end
