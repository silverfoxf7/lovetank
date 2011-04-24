require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar", 
      :password_confirmation => "foobar"
      }
  end
  
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
    # don't forget to include the test database 
  end
      
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
     
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email address" do
    addressess = %w[user@foo.com USER@foo.bar.org first.last@bar.jp]
    addressess.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

    
    it "should accept valid email address" do
      addressess = %w[user@foo,com USER_at_foo.bar.org last@bar.]
      addressess.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
  
    it "should reject dupe email addresses" do
      User.create!(@attr)
      user_with_dupe_email = User.new(@attr)
      user_with_dupe_email.should_not be_valid
    end
  
    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
    
    describe "passwords" do
      
      before(:each) do
        @user = User.new(@attr)
      end
      
      it "should have a password attribute" do
        @user.should respond_to(:password)
      end
      
      it "should have a password confirmation attribute" do
        @user.should respond_to(:password_confirmation)
      end
    end
    
    describe "password validations" do
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
      end
      
      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
      end
      
      it "should reject short passwords" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end
      
      it "should reject short passwords" do
        long = "a" * 41
        hash = @attr.merge(:password => long, :password_confirmation => long)
        User.new(hash).should_not be_valid
      end
                    
    end

    describe "password encryption" do
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end
      
      it "should set the ecnrypted password attribute" do 
        @user.encrypted_password.should_not be_blank
      end
      
      it "should have a salt" do
        # used to create an encryption hash based on time+password
        @user.should respond_to(:salt)
      end
      
      describe "has_password? method" do
        it "should exist" do
          @user.should respond_to(:has_password?)
        end
        
        it "should return true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end
        
        it "should return false if the passwords don't match" do
          @user.has_password?("invalid").should be_false
        end
      
      describe "authenticate method" do
        it "should exist" do
          User.should respond_to(:authenticate)  # class level test
        end
        
        it "should return nil on email/pw mismatch" do
          User.authenticate(@attr[:email], "wrongpass").should be_nil
        end
        
        it "should return nil for an email address with no user" do
          User.authenticate("bar@foo.com", @attr[:password]).should be_nil
        end
        
        it "should return the user on email/pw match" do
          User.authenticate(@attr[:email], @attr[:password]).should == @user
        end
        
      end
            
        
      end
      
    end
      
      describe "admin attribute" do

        before(:each) do
          @user = User.create!(@attr)
        end

        it "should respond to admin" do
          @user.should respond_to(:admin)
          # will only pass if the database-table has a column ":admin"
        end

        it "should not be admin by default" do
          @user.should_not be_admin
          # same as -->  @user.admin?.should_not be_true
          # we got this test to pass by making the default "false" in the migrate .rb file
        end

        it "should be convertible to admin" do
          @user.toggle!(:admin)
          # boolean columsn automatically get the toggle function
          @user.should be_admin
        end
      end
 
 # ------------ job posts
 
  describe "jobpost associations" do
    before(:each) do
      @user = User.create(@attr)
      @jp1 = Factory(:jobpost, :user => @user, :created_at => 1.day.ago)
      @jp2 = Factory(:jobpost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a jobpost attribute" do
      @user.should respond_to(:jobposts)
    end
    
    it "should have the jobposts in the right order" do
      @user.jobposts.should == [@jp2, @jp1]
    end
    
    it "should destroy associated jobposts" do
      @user.destroy
      [@jp1, @jp2].each do |jobposts|
        Jobpost.find_by_id(jobposts.id).should be_nil
      end
    end
    
    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:jobfeed)
      end

      it "should include the user's microposts" do
        @user.jobfeed.include?(@jp1).should be_true
        @user.jobfeed.include?(@jp2).should be_true
      end

      it "should not include a different user's microposts" do
        jp3 = Factory(:jobpost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.jobfeed.include?(jp3).should be_false
      end
    end
    
  end
 
 # ------------ job posts
  
    describe "micropost associations" do
       before(:each) do
        @user = User.create(@attr)
        @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
       end
       
       it "should have a microposts attribute" do
        @user.should respond_to(:microposts)
       end
       
       it "should have the right microposts in the right order" do
        @user.microposts.should == [@mp2, @mp1]
       end
    
      it "should destroy associated microposts" do
        @user.destroy
        [@mp1, @mp2].each do |microposts|
          # if you find_by_id, and it doesn't exist, then it will return nill
          Micropost.find_by_id(microposts.id).should be_nil
        end
      end    
      
      describe "status feed" do
        it "should have a feed" do
          @user.should respond_to(:feed)
        end
        
        it "should include the user's microposts" do
          # @user.feed.include?(@mp1).should be_true
          # include? is a method on an array that checks whether a thing is in the array
          @user.feed.should include(@mp1)
          # this is a re-factored form that does the same thing.
          @user.feed.should include(@mp2)
        end
        
        it "should not include a different user's microposts" do
          mp3 = Factory(:micropost, 
                        :user => Factory(:user, :email => Factory.next(:email)))
          @user.feed.should_not include(mp3)
        end
        
        it "should include the microposts of followed users" do
          followed = Factory(:user, :email => Factory.next(:email))
          mp3 = Factory(:micropost, :user => followed)
          @user.follow!(followed)
          @user.feed.should include(mp3)
        end
        
      end  
    end  
    
    describe "relationships" do

      before(:each) do
        @user = User.create!(@attr)
        @followed = Factory(:user)
      end


      it "should have a relationships method" do
        @user.should respond_to(:relationships)
      end 
      
      it "should have a following method" do
        @user.should respond_to(:following)
      end
      
      it "should follow another user" do
        @user.follow!(@followed)
        @user.should be_following(@followed)
      end
      
      it "should include the followed user in the followeding array" do
        @user.follow!(@followed)
        @user.following.should include(@followed)
      end
      
      it "should have an unfollow! method" do
        @user.should respond_to(:unfollow!)
      end
      
      it "should unfollow a user" do
        @user.follow!(@followed)
        @user.unfollow!(@followed)
        @user.should_not be_following(@followed)
      end
      
      it "should have reverse relationships method" do
        @user.should respond_to(:reverse_relationships)
      end
      
      it "should have a followers method" do
        @user.should respond_to(:followers)
      end
      
      it "should include the follower user in the followers array" do
        @user.follow!(@followed)
        @followed.followers.should include(@user)
      end
      
    end      
end











