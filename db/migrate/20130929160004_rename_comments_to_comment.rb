class RenameCommentsToComment < ActiveRecord::Migration
  def up
    rename_table :comments, :comments
  end

  def down
    rename_table :comments, :comments
  end
end
