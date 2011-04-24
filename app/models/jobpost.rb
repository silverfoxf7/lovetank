# == Schema Information
# Schema version: 20110226200446
#
# Table name: jobposts
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  location    :string(255)
#  poster      :string(255)
#  description :text
#  work_type   :integer
#  max_budget  :float
#  timeframe   :datetime
#  skills      :integer
#  expiretime  :datetime   
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  start_date  :datetime
#  overtime    :boolean
#  work_intensity :integer
#  email        :string
#
#  object.strftime("Printed on %m/%d/%Y")   #=> "Printed on 11/19/2007"
#  add an expected start_date
#  need to add boolean for "overtime" boolean
#  need to add work_intensity as expected hours/wk

class Jobpost < ActiveRecord::Base
  
#  default_scope :order => 'jobposts.created_at DESC'
# I removed the default_scope command so that I could implement the 
# Jobpost.order(params[:sort]) command within the _jobfeed_items partial.

  attr_accessible :title, :location, :poster, :description, :work_type, 
                  :max_budget, :duration, :skills, :start_date, :overtime,
                  :work_intensity, :email
  
  belongs_to :user
  has_many :bids,          :dependent => :destroy

  has_many :winationships, :foreign_key => "job_id", :dependent => :destroy
  has_many :workers, :through => :winationships, :source => :user

  validates :start_date, :presence => true
  validates :location, :presence => true, :length => { :maximum => 100 }
  validates :poster, :presence => true, :length => { :maximum => 100 }
  validates :description, :presence => true, :length => { :maximum => 1000 }
  validates :title, :presence => true, :length => { :maximum => 100 }
  
#  validates_numericality_of :work_type, :only_integer => true,
#                                        :message => "Can only be whole number."
#  validates_inclusion_of :work_type, :in => 1..3,
#                                     :message => "Can only be a number between 1 and 3."

  validates :work_type, :presence => true,  :length => { :maximum => 100 }
  

#  validates :skills, :presence => true,     :length => { :maximum => 100 }
  
#  validates_numericality_of :skills, :only_integer => true,
#                                         :message => "Can only be whole number."

  validates_numericality_of :work_intensity, :only_integer => true,
          :message => "must be the number of work hours per week."

#  validates_inclusion_of :skills, :in => 1..3,
#                                      :message => "Can only be a number between 1 and 3."
  # this RSPEC isn't testing properly.  Why?  Only works if I test validates 1-by-1.
  
   # need to validate 
          #  max_budget  :float
         #  timeframe   :datetime
  
  validates :user_id, :presence => true


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true,
                    :format => { :with => email_regex }


  def winner?(worker)
    self.winationships.find_by_worker_id(worker)
    # will return true if Jobpost has user has winner choosen
    # nil will return false; finding anything will be true
  end
  
  def pick_winner!(worker)
    self.winationships.create!(:worker_id => worker.id)
    # will create new row in Relationships table
    # only followed_id has to be set because follower_id is incremented automatically
  end

  def pick_loser!(worker)
    self.winationships.find_by_worker_id(worker).destroy
    # will create new row in Relationships table
    # only followed_id has to be set because follower_id is incremented automatically
  end

end