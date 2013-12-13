require 'spec_helper'

describe AttrHelpers::RequiredAttr do
  it "should initialize" do
    attribute = AttrHelpers::RequiredAttr.new(:name)

    attribute.name.should == :name
    attribute.required?.should == true
    attribute.key.should == 'name'
    attribute.serialize.should == true
  end
end