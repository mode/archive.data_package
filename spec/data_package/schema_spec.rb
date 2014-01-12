require 'spec_helper'

describe DataPackage::Schema do
  let(:json) {
    {
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
    schema = DataPackage::Schema.new(json)

    schema.fields.length.should == 1
    schema.fields.first.name.should == 'income'
    schema.primary_key.should == ['income']
    schema.has_primary_key?.should == true

    modified_json = json.merge('primaryKey' => 'income')
    schema.to_json.should == Yajl::Encoder.encode(modified_json, :pretty => true)
  end

  it "should initialize with string primaryKey" do
    modified_json = json.merge('primaryKey' => 'income')

    schema = DataPackage::Schema.new(modified_json)

    schema.fields.length.should == 1
    schema.fields.first.name.should == 'income'
    schema.primary_key.should == ['income']
    schema.has_primary_key?.should == true
    schema.to_json.should == Yajl::Encoder.encode(modified_json, :pretty => true)
  end

  it "should have primary key accessor" do
    modified_json = json.delete_if{|key, v| key == 'primaryKey'}

    schema = DataPackage::Schema.new(modified_json)

    schema.fields.length.should == 1
    schema.fields.first.name.should == 'income'
    schema.primary_key.should == []
    schema.has_primary_key?.should == false
    schema.to_json.should == Yajl::Encoder.encode(modified_json, :pretty => true)
  end
end