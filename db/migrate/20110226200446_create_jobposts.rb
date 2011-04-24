class CreateJobposts < ActiveRecord::Migration
  def self.up
    create_table :jobposts do |t|
      t.string :title
      t.string :location
      t.string :poster
      t.text :description
      t.string :work_type
      t.float :max_budget
      t.integer :duration
      t.string :skills
      t.datetime :expiretime
      t.datetime :start_date
      t.boolean :overtime
      t.integer :work_intensity
      t.integer :user_id

      t.timestamps
    end
    
    # since we expect to retrieve all the jobposts associated 
    # with a given user id, we add an index on the variables we want to retrieve
    add_index :jobposts, :title
    add_index :jobposts, :location
    add_index :jobposts, :poster
    add_index :jobposts, :description
    add_index :jobposts, :work_type
    add_index :jobposts, :max_budget
    add_index :jobposts, :duration
    add_index :jobposts, :skills
    add_index :jobposts, :expiretime
    add_index :jobposts, :start_date
    add_index :jobposts, :overtime
    add_index :jobposts, :work_intensity

    add_index :jobposts, :user_id
    
  end

  def self.down
    drop_table :jobposts
  end
end
