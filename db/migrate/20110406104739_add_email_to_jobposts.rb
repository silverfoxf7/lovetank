class AddEmailToJobposts < ActiveRecord::Migration
  def self.up
    add_column :jobposts, :email, :string
  end

  def self.down
    remove_column :jobposts, :email
  end
end
