class Comment < ActiveRecord::Base
  attr_accessible :created_by, :description
  attr_accessible :posts_id

  validates :description, :presence => true
  belongs_to :post
end
