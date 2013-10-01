require '../app/models/user'

describe User, "#email" do
  it "contains .com" do
    user = User.new
    user.hit("abc.com")
    user.hit("a@pqr.com")
    user.hit("b@gmail.com")
  end
end