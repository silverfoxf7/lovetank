class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], :unique => true
# this is a composite index that enforces uniqueness of pairs of
# (follower_id, followed_id), so that a user can’t follow another user more than once
  end

  def self.down
    drop_table :relationships
  end
end
