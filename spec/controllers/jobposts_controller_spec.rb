require 'spec_helper'

describe JobpostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      describe "failure" do

        before(:each) do
          # @attr = { :content => "" }
          @attr = {
            :title       => "",
            :location    => "",
            :poster      => "",
            :description => "",
            :work_type   => 1,   
            :max_budget  => 1,
            :timeframe   => Time.now,
            :skills      => 1}
        end

        it "should not create a jobpost" do
          lambda do
            post :create, :jobpost => @attr
          end.should_not change(Jobpost, :count)
        end

        it "should render the home page" do
          post :create, :jobpost => @attr
          response.should render_template('pages/home')
        end
      end

      describe "success" do

        before(:each) do
          # @attr = { :content => "Lorem ipsum" }
          @attr = {
            :title       => "Big Document Review Project",
            :location    => "New York, NY",
            :poster      => "Number One LPO",
            :description => "This is a document review project.",
            :work_type   => 1,
            :max_budget  => 35,
            :timeframe   => Time.now,
            :skills      => 1}
        end

        it "should create a jobpost" do
          lambda do
            post :create, :jobpost => @attr
          end.should change(Jobpost, :count).by(1)
        end

        it "should redirect to the home page" do
          post :create, :jobpost => @attr
          response.should redirect_to(root_path)
        end

        it "should have a flash message" do
          post :create, :jobpost => @attr
          flash[:success].should =~ /Project Created/i
        end
      end
    end
  
  
  
end
