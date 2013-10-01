  class User < ActiveRecord::Base

  before_save { self.email = email.downcase }

  #before we actually creating user we will create a unique token
  before_create :create_token

  attr_accessible :email, :first_name, :is_admin, :is_super_admin, :last_logged, :last_name, :password

  validates :first_name,presence: true
  validates :last_name,presence: true
  has_secure_password
  validates :password,presence: true    ,length: { maximum: 16,minimum: 4 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[gmail]+\.[com]+\z/
  validates :email,presence: true, format: { with: VALID_EMAIL_REGEX, message: 'is invalid. Email should end with @gmail.com'}   ,uniqueness:{ case_sensitive: false }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #here we can use any other algorithm like sha256 but it will take lot of time.so we will used sha1 ..we already used bcrypt(used in openBSD) for storing password
  #which is very slow but vey secure...
  #sha1 will be much faster and we require that because it will be going to used in each of the page

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
