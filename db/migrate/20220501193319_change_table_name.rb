class ChangeTableName < ActiveRecord::Migration[7.0]
  def change
    rename_table :microposts, :posts
  end
end
