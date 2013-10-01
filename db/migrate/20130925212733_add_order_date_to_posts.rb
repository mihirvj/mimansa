class AddOrderDateToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :order_date, :datetime
  end

  def down
    remove_column :posts, :order_date, :datetime
  end
end
