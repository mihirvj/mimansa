class CreateVotesPosts < ActiveRecord::Migration
  def change
    create_table :votes_posts do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
