require 'spec_helper'

describe DataPackage::Person do
  let(:json) {
    json = {
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }
  }

  it "should initialize" do
    person = DataPackage::Person.new('Josh F', {
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    })

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'
  end

  it "should load from json" do
    person = DataPackage::Person.load(json)

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'
  end

  it "should serialize to json" do
    person = DataPackage::Person.load(json)
    person.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end