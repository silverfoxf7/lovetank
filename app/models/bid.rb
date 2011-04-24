#      t.integer :amount # the amount of the bid for a project
#      t.integer :user_id  # ID of the person posting a bid
#      t.integer :jobpost_id # ID of the project being bid on
#      t.string :message # message to project being bid on

# may need to upgrade :message to "text" rather than "string"

class Bid < ActiveRecord::Base
  attr_accessible :amount, :jobpost_id, :message

  belongs_to :user
  # including belongs_to :jobpost, but not sure if necessary;  delete later if
  # unwarranted
  belongs_to :jobpost

#**** currently focusing on :message, not bid :amount ****
#  validates_numericality_of :amount, :only_integer => true,
#            :message => "must be the amount you wish to bid."

  validates :user_id, :presence => true
  validates :jobpost_id, :presence => true

#  add validates :message b/c don't want empty e-mails!
#  but do it later b/c don't want to ruin the rake db:populate.
#  validates :message, :presence => true

  default_scope :order => 'bids.created_at DESC'
end
