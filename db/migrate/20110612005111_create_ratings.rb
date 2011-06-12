class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.string :user_id
      t.string :photo_id
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
