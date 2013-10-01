class Tag < ActiveRecord::Base
  attr_accessible :tag_name

  validates :tag_name, :uniqueness => true
end
