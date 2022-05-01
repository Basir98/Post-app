class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id # enforeces uniqueness on follower_id 
    add_index :relationships, :followed_id  # enforces uniqueness on followed_id so that a user can not followe othe user more than once
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
