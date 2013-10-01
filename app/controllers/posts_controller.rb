class PostsController < ApplicationController
  include PostsHelper
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.search(params[:type], params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.json { render json: @tags }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comments = Comment.find_all_by_posts_id (@post.id)
    @comment = Comment.new
    @tags = Tag.all
    @categories = Category.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
      format.json { render json: @comments }
      format.json { render json: @comment }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @tags  = Tag.all
    @categories = Category.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @tags  = Tag.all
    @categories = Category.all
  end

  def comment_vote_up
    comment = Comment.find(params[:id])

    if(!valid_request? comment, :back, false)
      return
    end

    v = VotesComment.new(:comment_id => comment.id, :user_id => current_user.id)

    respond_to do |format|
      if v.save
        format.html { redirect_to :back, notice: 'Vote Up successful' }
        format.json { render json: :back, status: :created, location: v }
      else
        format.html { render action: "vote up" }
        format.json { render json: v.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote_up
    post = Post.find(params[:id])

    if(!valid_request? post, post, true)
      return
    end

    v = VotesPost.new(:post_id => post.id, :user_id => current_user.id)

    respond_to do |format|
      if v.save
        post.update_attribute(:order_date, Time.new)
        format.html { redirect_to post, notice: 'Vote Up successful' }
        format.json { render json: post, status: :created, location: v }
        #puts 'Vote up successful'
      else
        format.html { render action: "vote up" }
        format.json { render json: v.errors, status: :unprocessable_entity }
      end
    end
  end

  def valid_request? obj, redirect, is_post

    if(!signed_in?)
      respond_to do |format|
        format.html { redirect_to redirect, notice: 'You need to sign in to vote up.' }
        format.json { render json: redirect, status: :created, location: v }
      end
       return false
    end

    if (duplicate_vote_up? obj, current_user, is_post)
      respond_to do |format|
        #format.html {'You cannot vote for a post or a comment again.'}
        format.html { redirect_to redirect, notice: 'You cannot vote for a post or a comment again.' }
        format.json { render json: redirect, status: :created, location: v }
      end
      return false
    end

    if (is_owner? obj, current_user, is_post)
      respond_to do |format|
        format.html { redirect_to redirect, notice: 'You cannot vote for your own post or comment.' }
        format.json { render json: redirect, status: :created, location: v }
      end
      return false
    end

    return true
  end

  def comment_destroy
    comment = Comment.find(params[:id])

    comment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def comment
    post = Post.find(params[:id])

    @comment = Comment.new(:description => request.POST[:comment][:description],
                            :created_by => current_user.id, :posts_id => post.id)

    respond_to do |format|
      if @comment.save
        post.update_attribute(:order_date, Time.new)
        format.html { redirect_to :back, notice: 'Comment was successfully added.' }
        format.json { render json: :back, status: :created, location: post }
      else
        format.html { redirect_to :back }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @categories = Category.all
    @tags = Tag.all

    @post.created_by = current_user.id
    @post.order_date = Time.current

    p_tags = params[:all_tags]
    p_tag_new = params[:tag_new]

    @post.category_id = request.POST[:category]

    respond_to do |format|
      if @post.save
        if !p_tag_new.empty?
          tag_new = Tag.new(:tag_name => p_tag_new)
          if tag_new.save
              tag_map = PostsTag.new(:post_id => @post.id, :tag_id => tag_new.id)
              tag_map.save
            end
        end

        if !p_tags.empty?
          split_tags = p_tags.split(",")
            split_tags.each_index do |i|
            tag_id = split_tags[i]

            tag_map = PostsTag.new(:post_id => @post.id, :tag_id => tag_id)
            tag_map.save
          end
        end

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    p_tags = params[:all_tags]
    p_tag_new = params[:tag_new]
    @post.category_id = request.POST[:category]
    @post.order_date = Time.current

    respond_to do |format|
      if @post.update_attributes(params[:post])

        if !p_tag_new.empty?
          tag_new = Tag.new(:tag_name => p_tag_new)
          if tag_new.save
            puts '--------------------------------------------------------------------------------'
            puts 'Save success.. Now p_tag is ', p_tags
            puts '--------------------------------------------------------------------------------'

              if p_tags.nil? || p_tags.to_s.empty? then
                p_tags = tag_new.id
              else
                p_tags = p_tags.to_s + ',' + tag_new.id.to_s
              end
            end
        end

        if !p_tags.to_s.empty?
          split_tags = p_tags.to_s.split(",")
          PostsTag.destroy_all(:post_id => @post.id) # destroy to accommodate all changes

          puts '--------------------------------------------------------------------------------'
          puts split_tags
          puts '--------------------------------------------------------------------------------'

          split_tags.each_index do |i|
            tag_id = split_tags[i]

            tag_map = PostsTag.new(:post_id => @post.id, :tag_id => tag_id)
            tag_map.save
          end
        end

        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])

    comments = Comment.where(:posts_id => @post.id)

    comments.each do |comment|
      VotesComment.destroy_all(:comment_id => comment.id)
    end

    VotesPost.destroy_all(:post_id => @post.id)
    Comment.destroy_all(:posts_id => @post.id)
    PostsTag.destroy_all(:post_id => @post.id)

    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
