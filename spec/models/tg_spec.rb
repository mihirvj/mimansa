require 'spec_helper'

describe Tag do

  it "should validate uniqueness of" do
    should validate_uniqueness_of :tag_name
    end
end