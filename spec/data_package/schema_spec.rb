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
    schema.to_json.should == Yajl::Encoder.encode(json, :pretty => true)
  end
end