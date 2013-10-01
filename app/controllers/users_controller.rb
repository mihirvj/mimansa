  class UsersController < ApplicationController
   before_filter :check_signin_status, :except => [:new, :create]
   before_filter :correct_user,        :only   => [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    if(!current_user.is_super_admin && !current_user.is_admin)
      redirect_to posts_path
      return
    end

    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
    # GET /users/1.json
  def show
    if (!current_user.is_super_admin && !current_user.is_admin)
      redirect_to posts_path
      return
    end

    @user = User.find(params[:id])

    posts = Post.where(:created_by => @user.id)
    comments = Comment.where(:created_by => @user.id)
    votes_posts = VotesPost.where(:user_id => @user.id)
    votes_comments = VotesComment.where(:user_id => @user.id)

    #posts_per_month = posts.count(:group => "strftime('%m', created_at)")
    #comments_per_month = comments.count(:group => "strftime('%m', created_at)")
    #votes_posts_per_month = votes_posts.count(:group => "strftime('%m', created_at)")
    #votes_comments_per_month = votes_comments.count(:group => "strftime('%m', created_at)")

    posts_per_month = posts.count(:group => "extract(month from created_at)")
    comments_per_month = comments.count(:group => "extract(month from created_at)")
    votes_posts_per_month = votes_posts.count(:group => "extract(month from created_at)")
    votes_comments_per_month = votes_comments.count(:group => "extract(month from created_at)")

    @a_posts_per_month = [0,0,0,0,0,0,0,0,0,0,0,0]
    @a_comments_per_month = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @a_votes_per_month = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    posts_per_month.each do |key,value|
      @a_posts_per_month[key.to_i - 1] = value
    end

    comments_per_month.each do |key, value|
      @a_comments_per_month[key.to_i - 1] = value
    end

    votes_posts_per_month.each do |key, value|
      @a_votes_per_month[key.to_i - 1] = value
    end

    votes_comments_per_month.each do |key,value|
      @a_votes_per_month[key.to_i - 1] = @a_votes_per_month[key.to_i - 1] + value
    end

    puts '-----------------------------------------------------'
    puts @a_posts_per_month
    puts '-----------------------------------------------------'
    puts @a_comments_per_month
    puts '-----------------------------------------------------'
    puts @a_votes_per_month
    puts '-----------------------------------------------------'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
      format.json { render json: @a_posts_per_month}
      format.json { render json: @a_comments_per_month }
      format.json { render json: @a_votes_per_month }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if (signed_in?)
      redirect_to posts_path
      return
    end

    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
     #can be done by correct_user function
    # @user = current_user # extra code just to check that not anyone can manipulate url and edit other user..it worked
    #@user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    is_super_admin = 0
    is_admin = 0
    last_logged_in = Date.current

    puts '-----------------------------------------------------------------------'
    puts request.POST
    puts '-----------------------------------------------------------------------'

    if(User.all.count == 0)
      is_super_admin = 1
      #is_admin = 1
    end

    @user = User.new(:email => request.POST[:user][:email], :password => request.POST[:user][:password],
                     :first_name => request.POST[:user][:first_name],:last_name => request.POST[:user][:last_name],
                     :is_super_admin => is_super_admin, :is_admin => is_admin, :last_logged => last_logged_in)

    respond_to do |format|
      if @user.save

        sign_in @user
        flash[:success] = "Welcome to the Mimanzo!"

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

   def set_admin
     @user = User.where(:id => params[:id]).first

     respond_to do |format|
       if @user.update_attribute(:is_admin, true)
         format.html { redirect_to :back, notice: 'Admin successfully created' }
         format.json { head :no_content }
       else
         format.html { redirect_to :back, notice: 'Some error'}
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end
   end

   def unset_admin
     @user = User.where(:id => params[:id]).first

     respond_to do |format|
       if @user.update_attribute(:is_admin, false)
         format.html { redirect_to :back, notice: 'Admin successfully deleted' }
         format.json { head :no_content }
       else
         format.html { redirect_to :back, notice: 'Some error' }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end
   end

   # PUT /users/1
  # PUT /users/1.json
  def update

    #can be done by correct_user function
    #@user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Profile successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  private

  def check_param
    params.require(:user).permit(:email, :first_name, :last_name)

  end

  def check_signin_status
    unless signed_in?

      flash[:error] = "Please login to continue"
      redirect_to login_path
    end
  end

   def correct_user
     @user = User.find(params[:id])
     redirect_to(posts_path) unless current_user?(@user)
   end

end
