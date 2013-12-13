require 'spec_helper'

describe DataPackage::License do
  let(:json) {
    {
      'id' => 'PDDL',
      'url' => 'http://opendatacommons.org/licenses/pddl/'
    }
  }

  it "should initialize and serialize" do
    license = DataPackage::License.new(json)

    license.id.should == 'PDDL'
    license.url.should == 'http://opendatacommons.org/licenses/pddl/'
    license.to_json.should == Yajl::Encoder.encode(json, :pretty => true)
  end
end