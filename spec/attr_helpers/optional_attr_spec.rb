require 'spec_helper'

class ValueObj
  attr_accessor :name

  def initialize(attrs = {})
    @name = attrs[:name]
  end

  def is_name_required?
    true
  end
end

describe AttrHelper::OptionalAttr do
  it "should initialize" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::OptionalAttr.new(:name)

    attribute.name.should == :name
    attribute.key.should == 'name'
    attribute.serialize.should == true
  end
end