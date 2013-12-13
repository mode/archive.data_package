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

describe AttrHelper::RequiredAttr do
  it "should initialize" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::RequiredAttr.new(:name)

    attribute.name.should == :name
    attribute.key.should == 'name'
    attribute.serialize.should == true
    attribute.required?(valueObj).should == true
  end

  it "should check for if requirement with a proc" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::RequiredAttr.new(:name, :if => Proc.new{|parent| true})
    attribute.required?(valueObj).should == true
  end

  it "should check for if requirement with a symbol" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::RequiredAttr.new(:name, :if => :is_name_required?)
    attribute.required?(valueObj).should == true
  end

  it "should check for unless requirement with a proc" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::RequiredAttr.new(:name, :unless => Proc.new{|parent| true})
    attribute.required?(valueObj).should == false
  end

  it "should check for unless requirement with a symbol" do
    valueObj = ValueObj.new(:name => 'value')
    attribute = AttrHelper::RequiredAttr.new(:name, :unless => :is_name_required?)
    attribute.required?(valueObj).should == false
  end
end