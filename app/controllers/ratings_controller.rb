class RatingsController < ApplicationController
  before_filter :authenticate

  def rate
    @asset = Loveaction.find(params[:lid])
    Rating.delete_all(["rateable_type = 'Loveaction' AND rateable_id = ? AND user_id = ?", @asset.id, current_user.id])
    @asset.rate_it(params[:rating], current_user.id)
    #logger.info "Do you see me?"
    #raise "Do You See Me?"
    @lovely = Loveaction.find(params[:lid])
    @lovely.recip_rating = @asset.average_rating
#    @lovely.save
    @lovely.update_attribute(:recip_rating, @asset.average_rating)
    #render :update do |page|
    #  page.replace_html 'star-ratings-block', :partial => 'ratings/rating', :locals => { :asset => @asset }
    #  page.visual_effect :highlight, 'rate'
      redirect_to(@asset.user)

    Facebook.updateStatus(current_user.facebook_id,
                          current_user.facebook_token,
                          "I'm using Show me the Love!")
  end
end
