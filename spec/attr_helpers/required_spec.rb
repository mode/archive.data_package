require 'spec_helper'

class RequiredKlass
  include AttrHelpers::Required
  include AttrHelpers::Assignment

  attr_required :name
  attr_required :not_required, :if => Proc.new{|obj| false}
  attr_required :is_required, :unless => :false_value

  def initialize(attrs = {})
    write_attributes(attrs)
  end

  def false_value
    false
  end
end

class ChildRequiredKlass < RequiredKlass
end

class MutualExclusionKlass
  include AttrHelpers::Required
  include AttrHelpers::Assignment

  attr_required :data, :if => Proc.new{ |o| o.path.nil? && o.url.nil?  }
  attr_required :path, :if => Proc.new{ |o| o.data.nil? && o.url.nil?  }
  attr_required :url,  :if => Proc.new{ |o| o.data.nil? && o.path.nil? }
end

class AssignmentKlass
  include AttrHelpers::Required
  include AttrHelpers::Assignment

  attr_required :name

  def initialize(attrs = {})
    write_attributes(attrs)
  end

  def name=(value)
    write_attribute(:name, value + "test")
  end
end

describe AttrHelpers::Required do
  it "should initialize" do
    obj = RequiredKlass.new(:name => 'myvalue')

    obj.name.should == 'myvalue'

    obj.attr_required?(:name).should == true
    obj.attr_required?(:not_required).should == false
    obj.attr_required?(:is_required).should == true

    obj.missing_attributes.collect(&:name).should == [:is_required]
    obj.required_attributes.collect(&:name).should == [:name, :is_required]

    obj.attr_present?(:name).should == true
    obj.attr_missing?(:name).should == false

    obj.attr_present?(:is_required).should == false
    obj.attr_missing?(:is_required).should == true
  end

  it "should inherit" do
    obj = ChildRequiredKlass.new(:name => 'myvalue')

    obj.name.should == 'myvalue'

    obj.attr_required?(:name).should == true
    obj.attr_required?(:not_required).should == false
    obj.attr_required?(:is_required).should == true

    obj.missing_attributes.collect(&:name).should == [:is_required]
    obj.required_attributes.collect(&:name).should == [:name, :is_required]

    obj.attr_present?(:name).should == true
    obj.attr_missing?(:name).should == false

    obj.attr_present?(:is_required).should == false
    obj.attr_missing?(:is_required).should == true
  end

  it "should allow mutual exclusion" do
    obj = MutualExclusionKlass.new

    obj.missing_attributes.collect(&:name).should == [:data, :path, :url]
    obj.required_attributes.collect(&:name).should == [:data, :path, :url]

    obj.path = 'data.csv'
    obj.missing_attributes.collect(&:name).should == []
    obj.required_attributes.collect(&:name).should == [:path]
  end

  it "should write attributes through the setters" do
    obj = AssignmentKlass.new(:name => 'value')

    obj.name.should == 'valuetest'
  end
end