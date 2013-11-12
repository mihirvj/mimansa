require 'spec_helper'


describe CategoriesController do
  it "should create new category" do
    get 'new'
    assigns(:category).should be_kind_of(Category)
  end
  it "should pass params to category" do
    post 'create', :category => { :name => 'Question' }
    assigns[:category].name.should == 'Question'
  end
  end


