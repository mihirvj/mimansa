class RenameVotesPostsToVotesPost < ActiveRecord::Migration
  def up
    rename_table :votes_posts, :votes_posts
  end

  def down
    rename_table :votes_posts, :votes_posts
  end
end
