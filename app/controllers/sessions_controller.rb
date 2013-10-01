class SessionsController < ApplicationController
  skip_before_filter :check_user_state, :only => [:new, :destroy]
  def new

  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
   # id=User.find_by_id(params[:session][:email].downcase)
       # user.authenticate method work only if we have implemented has_secure_password method
        #this require we have a column named as "password_digest"
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if user.is_super_admin || user.is_admin
        redirect_to users_path
      else
        redirect_to posts_path
      end
    else
      flash.now[:error] = 'Invalid email and password combination'
      render 'new'

    end

  end

  def destroy
    sign_out
    redirect_to root_url

  end

  def notfound
    render 'sessions/notfound'
  end
end
