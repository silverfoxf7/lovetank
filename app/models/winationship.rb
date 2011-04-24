class Winationship < ActiveRecord::Base
#t.integer :job_id
#t.integer :worker_id

  attr_accessible :worker_id

#  belongs_to :job_id, :class_name => "Jobpost"
#  belongs_to :worker_id, :class_name => "User"

belongs_to :jobpost, :foreign_key => "job_id"
belongs_to :user, :foreign_key => "worker_id"

validates :job_id,    :presence => true
validates :worker_id, :presence => true

end
