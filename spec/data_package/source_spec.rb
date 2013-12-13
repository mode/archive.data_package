require 'spec_helper'

describe DataPackage::Source do
  let(:json) {
    json = {
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }
  }

  it "should initialize" do
    person = DataPackage::Source.new('Josh F', {
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    })

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'
  end

  it "should load from json" do
    person = DataPackage::Source.load(json)

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'
  end

  it "should serialize to json" do
    person = DataPackage::Source.load(json)
    person.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end