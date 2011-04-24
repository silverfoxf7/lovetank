class JobpostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :new, :destroy, :edit, :update]
  before_filter :authorized_user, :only => :destroy
  before_filter :only_poster_user, :only => [:new, :edit, :destroy, :update]
  
  def index
    # page to show all projects (aka BROWSE)
    if signed_in?
           # abv:  performing search through Jobpost model
     	     @title = "Projects"
     	     @jobpost = Jobpost.new
           @search = Jobpost.search(params[:search])
           # stores all of the search results
     	     @jobfeed_items = @search.
             order(sort_column + ' ' + sort_direction).
             paginate(:per_page => 5, :page => params[:page])
    else
    	     @title = "Projects"
     	     @jobpost = Jobpost.new
           @search = Jobpost.search(params[:search])
           # stores all of the search results
     	     @jobfeed_items = @search.
             paginate(:per_page => 5, :page => params[:page])
    end
  end

  def show   # page to show individual projects by ID
    @bid = Bid.new if signed_in?
    @title = "Projects"
    @job = Jobpost.find(params[:id])
    # stores all of the search results
    @jobfeed_items = @job
    @sortbidders = User.joins(:bids).
                  where(:bids => {:jobpost_id => params[:id]}).
                  search(params[:search])
    @bidders = @sortbidders.paginate(:per_page => 30, :page => params[:page])

#   Pre-load the text_area with PLE information.
      @bid.message =
        "<p>I found your project on
        <a href='premiumlegalexchange.com'>Premium Legal Exchange</a>.
        Please contact me about '#{@job.title}.'</p>

        <p>Attached is my resume for your consideration.</p>

        Thank you,<br />
        #{current_user.real_name}<br />"

  end

  def winners # page to show individual projects by ID
    @test = Jobpost.new #this is fake until we get ACH/CC payments done
#   @jobpost is referenced in _ACH_form.html.erb;  it is FAKE!
    @bid = Bid.new if signed_in?
    @title = "Projects"
    @job = Jobpost.find(params[:id])
    @winners = @job.workers.paginate(:per_page => 30, :page => params[:page])
#    @winners_amounts = @winners
    # stores all of the search results
    @jobfeed_items = @job
    @sortbidders = User.joins(:bids).
                  where(:bids => {:jobpost_id => params[:id]}).
                  search(params[:search])
    @bidders = @sortbidders.paginate(:per_page => 30, :page => params[:page])
    @commission = 0.10
    @amount_owed = 0
    
    @winners.each do |winner|
      @amount_owed = @amount_owed +
                     Bid.where({:jobpost_id => params[:id],
                                :user_id => winner.id}).
                     first.amount*@job.work_intensity
    end
    @collectible_amount = @amount_owed*@commission
  end


  def new
    # page to make a new project page (post_project)
    @title = "Post a New Project"
    if signed_in?
          @jobpost = Jobpost.new if signed_in?
          @jobfeed_items = current_user.jobfeed.paginate(:page => params[:page])
          # can probably comment this out @jobfeed_items
    end
  end
  
  def preview
    # page to display a summary of the user's project prior to creating it
	@job = current_user.jobposts.build(params[:jobpost])
	
  end

  def create  #literally creates the post, whereas "new" is for a new post
    @jobpost = current_user.jobposts.build(params[:jobpost])
      if @jobpost.save
        flash[:success] = "Project Created!"
        redirect_to projects_path  # re-directing to projects#index
      else
        @jobfeed_items = []
        render 'jobposts/new'
        # perhaps using render (rather than redirect_to) because this way
        # we can see the errors that are being shown in FLASH msg.
      end
  end

  def edit
    # page to edit project with params ID

  end

  def update
    # updates project with params ID
  end

  def destroy
    @jobpost.destroy
    redirect_back_or root_path
  end

private

  def authorized_user
    @jobpost = Jobpost.find(params[:id])
    redirect_to root_path unless current_user?(@jobpost.user)
  end

  def only_poster_user
    if current_user.account_type == 1 # this is the freelance attorney
        redirect_to root_path, :flash => {:error => "You cannot post a project."}
    end
  end

  def sort_column
    Jobpost.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
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
