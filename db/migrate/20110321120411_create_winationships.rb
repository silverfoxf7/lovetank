class CreateWinationships < ActiveRecord::Migration
  def self.up
    create_table :winationships do |t|
      t.integer :job_id
      t.integer :worker_id

      t.timestamps
    end
    add_index :winationships, :job_id
    add_index :winationships, :worker_id
    add_index :winationships, [:job_id, :worker_id], :unique => true
  end

  def self.down
    drop_table :winationships
  end
end
