require 'spec_helper'

describe PostsController do
  describe "GET index" do
    it "assigns @posts" do
      p=Post.create!(:subject => "Cog", :description =>"hi", :category_id =>123)
      get :index
      expect(assigns(:posts)).to eq([p])
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    it 'get email is successful' do
      get :index
      #response.should be_success
      response.should render_template(:index)

    end
  end
end