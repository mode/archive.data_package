require 'spec_helper'

class ValueObj
  attr_accessor :name

  def initialize(attrs = {})
    @name = attrs[:name]
  end

  def is_name_required?
    true
  end

  def serialized_name(name)
    name + 'method'
  end
end

describe AttrHelper::BaseAttr do
  it "should initialize" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::BaseAttr.new(:name)

    attribute.name.should == :name
    attribute.key.should == 'name'
    attribute.serialize.should == true
  end

  describe "Serialization" do
    it "should serialize by default" do
      valueObj = ValueObj.new(:name => 'value')
      attribute = AttrHelper::BaseAttr.new(:name)

      attribute.serializable?.should == true
      attribute.serialized(valueObj).should == 'value'
    end

    it "should serialize with a proc" do
      valueObj = ValueObj.new(:name => 'value')
      attribute = AttrHelper::BaseAttr.new(:name, :serialize => Proc.new{|name| name + 'proc'})

      attribute.serializable?.should == true
      attribute.serialized(valueObj).should == 'valueproc'
    end

    it "should serialize with a symbol" do
      valueObj = ValueObj.new(:name => 'value')
      attribute = AttrHelper::BaseAttr.new(:name, :serialize => :serialized_name)

      attribute.serializable?.should == true
      attribute.serialized(valueObj).should == 'valuemethod'
    end

    it "should disable serialization" do
      valueObj = ValueObj.new(:name => 'value')
      attribute = AttrHelper::BaseAttr.new(:name, :serialize => false)

      attribute.serializable?.should == false
      attribute.serialized(valueObj).should == nil
    end
  end
end