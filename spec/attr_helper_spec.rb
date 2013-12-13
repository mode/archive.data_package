require 'spec_helper'
require 'klass_helper'

describe AttrHelper do
  it "should initialize" do
    obj = KlassHelper::BaseKlass.new(:name => 'myvalue')

    obj.name.should == 'myvalue'

    obj.attr_required?(:name).should == true
    obj.attr_required?(:title).should == false
    obj.attr_required?(:format).should == false

    obj.missing_attributes.collect(&:name).should == [:data, :path, :url, :email, :web]
    obj.required_attributes.collect(&:name).should == [:name, :data, :path, :url, :email, :web]

    obj.attr_present?(:name).should == true
    obj.attr_missing?(:name).should == false

    obj.attr_present?(:data).should == false
    obj.attr_missing?(:data).should == true
  end

  it "should inherit" do
    obj = KlassHelper::ChildKlass.new(:name => 'myvalue')

    obj.name.should == 'myvalue'

    obj.attr_required?(:name).should == true
    obj.attr_required?(:title).should == false
    obj.attr_required?(:format).should == false

    obj.missing_attributes.collect(&:name).should == [:data, :path, :url, :email, :web]
    obj.required_attributes.collect(&:name).should == [:name, :data, :path, :url, :email, :web]

    obj.attr_present?(:name).should == true
    obj.attr_missing?(:name).should == false

    obj.attr_present?(:data).should == false
    obj.attr_missing?(:data).should == true
  end

  it "should allow mutual exclusion" do
    obj = KlassHelper::ChildKlass.new(:name => 'myvalue')

    obj.missing_attributes.collect(&:name).should == [:data, :path, :url, :email, :web]
    obj.required_attributes.collect(&:name).should == [:name, :data, :path, :url, :email, :web]

    obj.path = 'data.csv'
    obj.missing_attributes.collect(&:name).should == [:email, :web]
    obj.required_attributes.collect(&:name).should == [:name, :path, :email, :web]
  end

  it "should write attributes through the setters" do
    obj = KlassHelper::ChildKlass.new(:name => 'myvalue', :title => 'mytitle')

    obj.name.should == 'myvalue'
    obj.title.should == 'mytitlechild'
  end
end