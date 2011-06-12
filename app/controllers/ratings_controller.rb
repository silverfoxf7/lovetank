class RatingsController < ApplicationController
  before_filter :authenticate

  def rate
    @asset = Loveaction.find(params[:lid])
    
    Rating.delete_all(["rateable_type = 'Loveaction' AND rateable_id = ? AND user_id = ?", @asset.id, current_user.id])
    @asset.rate_it(params[:rating], current_user.id)

    @lovely = Loveaction.find(params[:lid])
    @temp = Relationship.find_by_follower_id(params[:id])
    @lovely.recip_id = User.find(@temp.followed_id)
    @lovely.recip_rating = params[:rating]
    @lovely.save

    render :update do |page|
      page.replace_html 'star-ratings-block', :partial => 'ratings/rating', :locals => { :asset => @asset }
      page.visual_effect :highlight, 'rate'
    end
  end
end
