module PostsHelper
  def votes_count(id)
    num = VotesPost.where(:post_id => id).count
    return num
  end

  def votes_comment_count(id)
    num = VotesComment.where(:comment_id => id).count
    return num
  end

  def comment_count(pid)
    num = Comment.where(:posts_id => pid).count
    return num
  end

  def user_name(uid)
    user = User.where(:id => uid).first

    user.first_name + ' '  + user.last_name
  end

  def tag_present(tid, pid)
    num = PostsTag.where(:post_id => pid, :tag_id => tid).count

    return num > 0
  end

  def category_present(cid, pid)
    num = Post.where(:id => pid, :category_id => cid).count

    return num > 0
  end

  def duplicate_vote_up?(post, user)
    num = VotesPost.where(:post_id => post.id, :user_id => user.id)

    num.count > 0
  end

  def is_owner?(post,user)
    num = Post.where(:id => post.id, :created_by => user.id)

    num.count > 0
  end


  def duplicate_vote_up?(rel_obj, user, is_post)
    if (is_post)
      num = VotesPost.where(:post_id => rel_obj.id, :user_id => user.id)
    else
      num = VotesComment.where(:comment_id => rel_obj.id, :user_id => user.id)
    end

    num.count > 0
  end

  def is_owner?(rel_obj, user, is_post)
    if (is_post)
      num = Post.where(:id => rel_obj.id, :created_by => user.id)
    else
      num = Comment.where(:id => rel_obj.id, :created_by => user.id)
    end

    num.count > 0
  end
end
