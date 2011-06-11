class CreateLoveactions < ActiveRecord::Migration
  def self.up
    create_table :loveactions do |t|
      t.string :act
      t.integer :user_id
      t.datetime :date
      t.integer :recip_id
      t.integer :my_rating
      t.integer :recip_rating

      t.timestamps
    end
  end

  def self.down
    drop_table :loveactions
  end
end
