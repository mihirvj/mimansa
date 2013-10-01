class ApplicationController < ActionController::Base
  before_filter :check_user_state

  protect_from_forgery
  include SessionsHelper

  def check_user_state

  end
end
