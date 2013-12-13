require 'spec_helper'

describe DataPackage::Dialect do
  let(:json) {
    {
      "delimiter" => "\t",
      "doublequote" => false,
      "lineterminator" => "\n",
      "quotechar" => "\"",
      "skipinitialspace" => true
    }
  }

  it "should initialize with defaults" do
    dialect = DataPackage::Dialect.new

    puts dialect.inspect

    dialect.delimiter.should == ','
    dialect.double_quote.should == false
    dialect.line_terminator.should == "\n"
    dialect.quote_char.should == "\""
    dialect.skip_initial_space.should == false
  end

  it "should initialize and serialize" do
    dialect = DataPackage::Dialect.new(json)

    dialect.delimiter.should == "\t"
    dialect.double_quote.should == false
    dialect.line_terminator.should == "\n"
    dialect.quote_char.should == "\""
    dialect.skip_initial_space.should == true

    dialect.to_json.should == Yajl::Encoder.encode(json, :pretty => true)
  end
end