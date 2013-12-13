require 'spec_helper'
require 'resource_helper'

describe DataPackage::Resource do
  let(:json) {
    standard_resource
  }

  it "should initialize and serialize" do    
    resource = DataPackage::Resource.new(base_path, json)

    resource.format.should == 'csv'
    resource.name.should == 'standard'
    resource.path.should == 'standard.csv'

    resource.schema.fields.length.should == 10
    resource.schema.primary_key.should == ['id']

    puts resource.schema.to_hash.inspect

    # puts resource.to_hash

    # resource.to_hash.should == json.merge('format' => 'csv')
  end

  describe "#each_row" do
    it "should enumerate over inline data" do

    end

    it "should enumerate over local file data" do

    end
  end
end