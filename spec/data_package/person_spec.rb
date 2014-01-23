require 'spec_helper'

describe DataPackage::Person do
  let(:json) {
    {
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }
  }

  it "should initialize and serialize" do
    person = DataPackage::Person.new(json)

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'

    person.to_json.should == JSON.pretty_generate(json)
  end
end