require 'spec_helper'

describe DataPackage::Base do
  it "should list required and optional attributes" do
    base = DataPackage::Base.new

    base.required_attributes.should == []
    base.optional_attributes.should == []
  end
end