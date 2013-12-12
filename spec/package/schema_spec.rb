require 'spec_helper'

describe DataPackage::Schema do
  let(:json) {
    json = {
      'fields' => [
        {
          'name' => 'income',
          'type' => 'number'
        }
      ],

      'primaryKey' => ['income']
    }
  }

  it "should initialize" do
    field = DataPackage::Field.new('income', :number)
    schema = DataPackage::Schema.new([field], :primary_key => ['income'])

    schema.fields.should == [field]
    schema.primary_key.should == ['income']
  end

  it "should load from json" do
    schema = DataPackage::Schema.load(json)
    field = DataPackage::Field.new('income', :number)

    schema.fields.should == [field]
    schema.primary_key.should == ['income']
  end

  it "should serialize to json" do
    schema = DataPackage::Schema.load(json)
    schema.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end