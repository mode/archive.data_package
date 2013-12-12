require 'spec_helper'

describe DataPackage::Dialect do
  let(:json) {
    json = {
      "delimiter" => "\t",
      "doublequote" => false,
      "lineterminator" => "\n",
      "quotechar" => "\"",
      "skipinitialspace" => true
    }
  }

  it "should initialize" do
    dialect = DataPackage::Dialect.new

    dialect.delimiter.should == ','
    dialect.double_quote.should == false
    dialect.line_terminator.should == "\n"
    dialect.quote_char.should == "\""
    dialect.skip_initial_space.should == false
  end

  it "should load from json" do
    dialect = DataPackage::Dialect.load(json)

    dialect.delimiter.should == "\t"
    dialect.double_quote.should == false
    dialect.line_terminator.should == "\n"
    dialect.quote_char.should == "\""
    dialect.skip_initial_space.should == true
  end

  it "should serialize to json" do
    dialect = DataPackage::Dialect.load(json)
    dialect.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end