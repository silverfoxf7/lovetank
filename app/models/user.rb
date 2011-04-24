# == Schema Information
# Schema version: 20110221145226
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#    add_column :users, :real_name, :string
#    add_column :users, :status, :integer
#    add_column :users, :skills, :text
#    add_column :users, :location, :string
#    add_column :users, :rating, :integer
#    add_column :users, :jobs_completed, :integer
#    add_column :users, :tagline, :text
#    add_column :users, :skill1, :string
#    add_column :users, :skill2, :string
#    add_column :users, :skill3, :string
#    add_column :users, :resume, :text
#    add_column :users, :account_type, :integer

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation,
                  :real_name, :status, :skills, :location, :tagline, 
                  :skill1, :skill2, :skill3, :resume, :account_type,
                  :rating, :jobs_completed
  #allows users to enter/change their name & email, pswd

  has_many :bids,          :dependent => :destroy
  accepts_nested_attributes_for :bids

  has_many :jobposts,      :dependent => :destroy
  has_many :microposts,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
                          # hardwires the key (id) from one table to another 
  has_many :reverse_relationships, :dependent => :destroy,
                           :foreign_key => "followed_id",
                           :class_name => "Relationship"
                           # class_name tells Rails to fake the reverse_relationships model

  has_many :reverse_winationships, :dependent => :destroy,
                           :foreign_key => "worker_id",
                           :class_name => "Winationship"
                           # class_name tells Rails to fake the reverse_relationships model
  has_many :billable_jobs, :through => :reverse_winationships, :source => :jobpost


  has_many :following, :through => :relationships, 
                       :source => :followed
  has_many :followers, :through => :reverse_relationships, 
                       :source => :follower
                       # :source tells Rails which key column to look at                  

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 } 
  validates :email, :presence => true, 
                    :format => { :with => email_regex },     
                    :uniqueness => { :case_sensitive => false }
  # must follow format validation
  # must follow unique validation
  
  validates :password,  :presence => true, 
                        :confirmation => true,
                        :length   => { :within => 6..40 } 

  validates :account_type,  :presence => true


  # we want to create the encrypted password before the user gets saved to the DB 
  before_save :encrypt_password
  
  def feed
    Micropost.from_users_followed_by(self)    
  end
  
  def jobfeed
    Jobpost.where("user_id = ?", id)    
  end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
    # will return true if user if following another user
    # nil will return false; finding anything will be true
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
    # will create new row in Relationships table
    # only followed_id has to be set because follower_id is incremented automatically
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy    
  end
  
  
  def has_password?(submitted_password)
    # compare submtted password with the encrypted password.
    # this is for the sign-in; user enters a pw; must compare 
    # it to the stored encrypted_password for that user. This method 
    # returns "true" if the passwords match.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)  #can also be User.authenticate; we're using self because it's a valid class "self" reference
     user = User.find_by_email(email)
     # inside a self class method you can omit the "User." prefix.  It's implicit.
     return nil  if  user.nil?
     return user if user.has_password?(submitted_password) #returns true if submitted pw == encrypted pw
  end  
     # This method handles two cases (1. invalid email and 2. a successful match) with explicit 
     # return keywords, and handles the third case (password mismatch) implicitly, 
     # since in that case we reach the end of the method, which automatically returns nil.   
  # ------------------------------------------------------------------------
  # ------------------------------------------------------------------------
  # BELOW -- additions for authenticating sign-in users from Lesson #9

  def self.authenticate_with_salt(id, cookie_salt)
     user = find_by_id(id)
     (user && user.salt == cookie_salt) ? user : nil
     # IF (boolean AND boolean)? return value for TRUE : return value for FALSE
  end 
  
      
  private
    def encrypt_password
        self.salt = make_salt if new_record?  # make a salt only if it's a new record
        self.encrypted_password = encrypt(self.password)
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
        
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end








