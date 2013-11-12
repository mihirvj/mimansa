require 'spec_helper'

describe User do

  it "should validate presence of" do
    should validate_presence_of :first_name
    should validate_presence_of :last_name
  end

  it "should not save without an password" do
    user = User.new
    assert !user.save, "Saved user without password"
  end
  end