class Post < ActiveRecord::Base
  attr_accessible :created_by, :description, :subject, :category_id, :order_date
  #attr_reader :created_at

  validates :subject, :presence => true
  validates :description, :presence => true
  validates :category_id, :presence => true

  has_many :comments
  belongs_to :category

  private
  def self.search_users(search)
    #users = User.all(:conditions => ['first_name LIKE ?', "%#{search}%"])
    users = User.all(:conditions => ['first_name ILIKE ?', "%#{search}%"])

    if users
      Post.find_all_by_created_by(users, :order => 'order_date DESC')
    else
      Array.new
    end
  end

  def self.search_content(search)
    #Post.all(:conditions => ['subject like ? or description LIKE ?', "%#{search}%", "%#{search}%"], :order => 'order_date DESC')
    Post.all(:conditions => ['subject ilike ? or description ILIKE ?', "%#{search}%", "%#{search}%"], :order => 'order_date DESC')
  end

  def self.search_tags(search)
    tagid = Tag.all(:conditions => ['tag_name = ?', "#{search}"])

    if tagid
      #This wil give us all post id
      postid = PostsTag.all(:conditions => ['tag_id = ?', tagid])

      if postid
        post_list=[]
        postid.each do |i|
          post_list << i.post_id
        end

        Post.all(:conditions => ['id in (?)', post_list], :order => 'order_date DESC')

      else
        Array.new
      end
    else
      Array.new
    end
  end

  def self.search_categories(search)
    #category = Category.first(:conditions => ['name LIKE ?', "%#{search}%"])
    category = Category.first(:conditions => ['name ILIKE ?', "%#{search}%"])
    if category
      Post.find_all_by_category_id(category.id, :order => 'order_date DESC')
    else
      Array.new
    end
  end

  public
  def self.search(type, search)
    case
      when type == "user"
        search_users(search)

      when type == "content"
        search_content(search)

      when type == "tag"
        search_tags(search)

      when type == "category"
        search_categories(search)

      else
        Post.all(:order => 'order_date DESC')
    end
  end
end
