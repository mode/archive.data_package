require 'spec_helper'
require 'klass_helper'

describe AttrHelper do
  it "should serialize" do
    obj = KlassHelper::BaseKlass.new(:name => 'myvalue')
    obj.to_json.should == JSON.pretty_generate({:name => 'myvalue'})
  end
end