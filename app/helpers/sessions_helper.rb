module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token


    #here we can do manipulation as we are storing unencrypted token in cookie so we can encrypt the token before storing to cookie.
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end



  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
   # @current_user ||= User.find_by(remember_token: remember_token)
    @current_user ||= User.where(remember_token: remember_token).first
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    redirect_to root_url
  end
end
