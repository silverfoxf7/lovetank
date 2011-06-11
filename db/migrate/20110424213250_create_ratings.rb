class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :matter_id
      t.integer :communication
      t.integer :value
      t.integer :satisfaction

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
