require 'spec_helper'

describe PostsController, "#show" do
  context "for a given post"  do
    before do
      Post.create!(:subject => "Welcome", :description =>"hi", :category_id =>123)
      Post.create!(:subject => "Ruby", :description =>"Not working", :category_id =>1234)
      get :show, :id => 1
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should_not set_the_flash }

  end
end