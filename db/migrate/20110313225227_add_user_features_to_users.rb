class AddUserFeaturesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :real_name, :string
    add_column :users, :status, :integer
    add_column :users, :skills, :text
    add_column :users, :location, :string
    add_column :users, :rating, :integer
    add_column :users, :jobs_completed, :integer
    add_column :users, :tagline, :text
    add_column :users, :skill1, :string
    add_column :users, :skill2, :string
    add_column :users, :skill3, :string
    add_column :users, :resume, :text
    add_column :users, :account_type, :integer
  end

  def self.down
    remove_column :users, :resume
    remove_column :users, :skill3
    remove_column :users, :skill2
    remove_column :users, :skill1
    remove_column :users, :tagline
    remove_column :users, :jobs_completed
    remove_column :users, :rating
    remove_column :users, :location
    remove_column :users, :skills
    remove_column :users, :status
    remove_column :users, :real_name
    remove_column :users, :account_type
  end
end
