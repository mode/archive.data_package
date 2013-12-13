require 'spec_helper'

describe DataPackage::Source do
  let(:json) {
    {
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }
  }

  it "should initialize and serialize" do
    person = DataPackage::Source.new(json)

    person.name.should == 'Josh F'
    person.email.should == 'josh@modeanalytics.com'
    person.web.should == 'http://www.modeanalytics.com/josh'

    person.to_hash.should == json
    person.to_json.should == Yajl::Encoder.encode(person.to_hash, :pretty => true)
  end
end