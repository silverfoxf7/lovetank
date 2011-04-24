require 'spec_helper'

describe Jobpost do

  before(:each) do
    @user = Factory(:user)
    @attr = {
      :title       => "Big Document Review Project",
      :location    => "New York, NY",
      :poster      => "Number One LPO",
      :description => "This is a document review project.",
      :work_type   => 1,   # 1 refers to doc review
      :max_budget  => 35,
      :timeframe   => Time.now,
      :skills      => 1}   
      # :expiretime  => 
      # :user_id     => 1
      # :created_at  =>
      # :updated_at  =>
          
  end

  it "should create a new instance given valid attributes" do
    # Jobpost.create!(@attr)
    @user.jobposts.create!(@attr)
  end
  
  describe "user associations" do

      before(:each) do
        @jobpost = @user.jobposts.create(@attr)
      end

      it "should have a user attribute" do
        @jobpost.should respond_to(:user)
      end

      it "should have the right associated user" do
        @jobpost.user_id.should == @user.id
        @jobpost.user.should == @user
      end
  end
    
  describe "validations" do
    
      it "should have a user id" do
        Jobpost.new(@attr).should_not be_valid
      end
      
      # it "should require nonblank title" do
      #   @user.jobposts.build(:title => "   ").should_not be_valid
      # end

      # it "should reject long title" do
      #   @user.jobposts.build(:title => "a" * 7).should_not be_valid
      # end
      
      # it "should require nonblank location" do
      #   @user.jobposts.build(:location => "   ").should_not be_valid
      # end
      # 
      # it "should reject long location" do
      #   @user.jobposts.build(:location => "a" * 7).should_not be_valid
      # end
      # 
      # it "should require nonblank poster" do
      #   @user.jobposts.build(:poster => "   ").should_not be_valid
      # end
      # 
      # it "should reject long poster" do
      #   @user.jobposts.build(:poster => "a" * 7).should_not be_valid
      # end
      # 
      # it "should require nonblank description" do
      #   @user.jobposts.build(:description => "   ").should_not be_valid
      # end
      # 
      # it "should reject long description" do
      #   @user.jobposts.build(:description => "a" * 100).should_not be_valid
      # end
      # 
      # it "should require nonblank work_type" do
      #   @user.jobposts.build(:work_type => "   ").should_not be_valid
      # end
      # 
      # it "should reject text" do
      #   @user.jobposts.build(:work_type => "Hi").should_not be_valid
      # end
      # 
      # it "should reject numbers beyond range" do
      #   @user.jobposts.build(:work_type => 4).should_not be_valid
      # end
   
  end
    
    
end
