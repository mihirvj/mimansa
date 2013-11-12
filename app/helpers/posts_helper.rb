module PostsHelper
  # returns count of votes for a given post id
  def votes_count(id)
    num = VotesPost.where(:post_id => id).count
    return num
  end

  # returns count of votes for comments for given post id
  def votes_comment_count(id)
    num = VotesComment.where(:comment_id => id).count
    return num
  end

  # returns count of comments for a given post
  def comment_count(pid)
    num = Comment.where(:posts_id => pid).count
    return num
  end

  # gets user name
  def user_name(uid)
    user = User.where(:id => uid).first

    if(user.nil?)
      'Anonymous'
    else
      user.first_name + ' '  + user.last_name
    end
  end

  # gets whether the tag is present for given post id
  def tag_present(tid, pid)
    num = PostsTag.where(:post_id => pid, :tag_id => tid).count

    return num > 0
  end

  # returns whether category is present for given post id
  def category_present(cid, pid)
    num = Post.where(:id => pid, :category_id => cid).count

    return num > 0
  end

  # returns whether user is trying to make duplicate vote up
  def duplicate_vote_up?(post, user)
    num = VotesPost.where(:post_id => post.id, :user_id => user.id)

    num.count > 0
  end

  # returns true if user is owner of post
  def is_owner?(post,user)
    num = Post.where(:id => post.id, :created_by => user.id)

    num.count > 0
  end

  # returns whether user is trying to make duplicate vote up for post or comment
  def duplicate_vote_up?(rel_obj, user, is_post)
    if (is_post)
      num = VotesPost.where(:post_id => rel_obj.id, :user_id => user.id)
    else
      num = VotesComment.where(:comment_id => rel_obj.id, :user_id => user.id)
    end

    num.count > 0
  end

  # returns true if user is owner of post or comment
  def is_owner?(rel_obj, user, is_post)
    if (is_post)
      num = Post.where(:id => rel_obj.id, :created_by => user.id)
    else
      num = Comment.where(:id => rel_obj.id, :created_by => user.id)
    end

    num.count > 0
  end
end
