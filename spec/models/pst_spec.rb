require 'spec_helper'

describe Post do
  it "has no posts in the database" do
    expect(Post).to have(:no).records
    expect(Post).to have(0).records
  end

it "has one record" do
  Post.create!(:subject => "Ruby", :description =>"doubt in ruby modules", :category_id =>123)
  expect(Post).to have(1).record
end

it "counts only records that match a query" do
  Post.create!(:subject => "Ruby", :description =>"doubt in ruby modules", :category_id =>123)
  expect(Post.where(:subject => "Ruby")).to have(1).record
  expect(Post.where(:subject => "Rails")).to have(0).records
end

  end