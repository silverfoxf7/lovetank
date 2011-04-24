class BidsController < ApplicationController
  before_filter :authenticate, :only => [:create, :new, :destroy, :edit, :update]
  before_filter :authorized_user, :only => :destroy
  before_filter :bid_amount_check, :only => :create
  before_filter :one_bid_per_user, :only => :create
  before_filter :bidder_cannot_be_poster, :only => :create

  def create  #literally creates the bid, whereas "new" is for a new post page
#    @bid = current_user.bids.build(params[:bid])
      if @bid.save
#       include the ActionMailer here!
        UserMailer.apply_for_job(current_user, @job, @bid).deliver
        flash[:success] = "Application Submitted!"
        redirect_to :back
# redirects back to the project that you posted at
      else
        @bidfeed_items = []
        redirect_to :back, :alert => "Please submit an appropriate application."
      end
  end

  def destroy
    @bid.destroy
    redirect_back_or root_path
  end

private

  def authorized_user
    @bid = Bid.find(params[:id])
    redirect_to root_path unless current_user?(@bid.user)
  end
  
  def bid_amount_check  #checks whether bid is too high and whether bid more than 1?
    @bidcheck = current_user.bids.new(params[:bid])
#    instantiates new bid, but does not save to DB
    @job = Jobpost.find(@bidcheck.jobpost_id)
#    finds current jobpost we're talking about

#  currently focusing on :message, rather than bid :amount.  Thus, do
#  not need to check the BID AMOUNT.  *******************
#    if @bidcheck.amount <= @job.max_budget
#      @bid = current_user.bids.build(params[:bid])
#    else
#      @bid = current_user.bids.new(params[:bid]) #no save.
#      redirect_to :back, :alert => "You exceeded the max budget. Please enter a new bid."
#    end
  end

  def bidder_cannot_be_poster
    # if jobpost.user_id == current_user then NO proceed.
    @job = Jobpost.find(@bidcheck.jobpost_id)
    if @job.user_id == current_user.id
      @bid = current_user.bids.new(params[:bid]) #no save.
      redirect_to :back, :alert => "You cannot apply for your own project."
      #Q: is this the best place to do this? Shouldn't even allow person to bid.
      # consider altering the HTML based on bid_count so that SUBMIT not shown.
    else
      @bid = current_user.bids.build(params[:bid])
    end
  end

  def one_bid_per_user  #checks whether bid is too high and whether bid more than 1?
    @bid_count = 0
    @job = Jobpost.find(@bidcheck.jobpost_id)
    @allbids = @job.bids.all
    # checks each bid_id, if match, then increase counter
    @allbids.each do |i|
      if i.user_id == current_user.id
        @bid_count = @bid_count + 1
      end
    end
# now check counter to see if this user has previous posts.
    if @bid_count < 1  # no previous posts, then build
      @bid = current_user.bids.build(params[:bid])
    else
      @bid = current_user.bids.new(params[:bid]) #no save.
      redirect_to :back, :alert => "You have already applied for this project."
      #Q: is this the best place to do this? Shouldn't even allow person to bid.
      # consider altering the HTML based on bid_count so that SUBMIT not shown.
    end
  end

  def sort_column
    Bid.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    # says: if Jobpost model has a column based on params:sort, then use
        # that content to sort the column, otherwise use "title" as default
    # might want to change the default parameter "title" to "expires in"
    # once that feature is implemented
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
    # made "desc" the default so we can see recently posted projects first.
  end

end