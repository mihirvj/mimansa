class RenamePostsTagsToPostsTag < ActiveRecord::Migration
  def up
    rename_table :posts_tags, :posts_tags
  end

  def down
    rename_table :posts_tags, :posts_tags
  end
end
