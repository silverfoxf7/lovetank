class CreateMatters < ActiveRecord::Migration
  def self.up
    create_table :matters do |t|
      t.string :name
      t.string :firm
      t.string :email
      t.string :mtr_name
      t.string :mtr_number

      t.timestamps
    end
  end

  def self.down
    drop_table :matters
  end
end
