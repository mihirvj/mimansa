class CreateVotesComments < ActiveRecord::Migration
  def change
    create_table :votes_comments do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
  end
end
