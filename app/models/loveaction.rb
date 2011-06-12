class Loveaction < ActiveRecord::Base

# == Schema Information
# Table name: loveactions
#
#      t.string :act
#      t.integer :user_id
#      t.datetime :date
#      t.integer :recip_id
#      t.integer :my_rating
#      t.integer :recip_rating
#
#      t.timestamps

#  object.strftime("Printed on %m/%d/%Y")   #=> "Printed on 11/19/2007"
  

  attr_accessible :act, :date, :my_rating, :recip_rating

  belongs_to :user

  acts_as_rateable

  validates :act, :presence => true, :length => { :maximum => 140}
  validates :user_id, :presence => true

  default_scope :order => 'loveactions.created_at DESC'

    scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
                                                       :user_id => user)
    end  
end