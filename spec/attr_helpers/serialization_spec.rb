require 'spec_helper'
require 'klass_helper'

describe AttrHelper do
  it "should serialize" do
    obj = BaseKlass.new(:name => 'myvalue')
    obj.to_json.should == JSON.generate({:name => 'myvalue'})
  end
end