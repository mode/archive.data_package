require 'spec_helper'

describe DataPackage::License do
  let(:json) {
    json = {
      'id' => 'PDDL',
      'url' => 'http://opendatacommons.org/licenses/pddl/'
    }
  }

  it "should load from json" do
    license = DataPackage::License.load(json)

    license.id.should == 'PDDL'
    license.url.should == 'http://opendatacommons.org/licenses/pddl/'
  end

  it "should serialize to json" do
    license = DataPackage::License.load(json)
    license.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end