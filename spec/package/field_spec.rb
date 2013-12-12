require 'spec_helper'

describe DataPackage::Field do
  it "should initialize" do
    field = DataPackage::Field.new('income', :number, {'title' => 'Personal Income'})

    field.name.should == 'income'
    field.type.should == :number
    field.title.should == 'Personal Income'
  end

  it "should load from json" do
    json = {
      'name' => 'income',
      'type' => 'number',
      'title' => 'Personal Income',
      'description' => 'My Desc',
      'format' => 'normal'
    }

    field = DataPackage::Field.load(json)

    field.name.should == 'income'
    field.type.should == :number
    field.title.should == 'Personal Income'
    field.description.should == 'My Desc'
    field.format.should == 'normal'
  end

  it "should serialize to json" do
    field = DataPackage::Field.new('income', :number, {'title' => 'Personal Income'})

    serialized = field.to_json
    serialized.should == Yajl::Encoder.encode({
      'name' => 'income',
      'type' => 'number',
      'title' => 'Personal Income'
    }, :pretty => true)
  end
end