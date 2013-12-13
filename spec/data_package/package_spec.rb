require 'spec_helper'

describe DataPackage::Package do
  let(:dialect) {
    {
      "delimiter" => "\t",
      "doublequote" => false,
      "lineterminator" => "\n",
      "quotechar" => "\"",
      "skipinitialspace" => false
    }
  }

  let(:schema) {
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

  let(:sources) {
    [{
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }]
  }

  let(:licenses) {
    [{
      'id' => 'PDDL',
      'url' => 'http://opendatacommons.org/licenses/pddl/'
    }]
  }

  let(:maintainers) {
    [{
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }]
  }

  let(:contributors) {
    [{
      'name' => 'Josh F',
      'email' => 'josh@modeanalytics.com',
      'web' => 'http://www.modeanalytics.com/josh'
    }]
  }

  let(:json) {
    {
      'name' => 'mypackage',
      'title' => 'Tells me about things',
      'version' => '0.0.1',

      'sources' => sources,
      'licenses' => licenses,
      'maintainers' => maintainers,
      'contributors' => contributors,

      'resources' => [{
        "name" => "mydataset",
        "format" => "csv",
        "path" => "data.csv",
        "dialect" => dialect,
        'schema' => schema
      }]
    }
  }

  let(:tmpdir) {
    Dir.mktmpdir
  }

  it "should init" do
    package = DataPackage::Package.init(tmpdir, 'mypackage')

    package.name.should == 'mypackage'
    package.version.should == '0.0.1'
    package.resources.should == []
  end

  it "should raise on open if the package file doesn't exist" do
    tmpdir = Dir.mktmpdir
    expect { package = DataPackage::Package.open(tmpdir) }.to raise_error
  end

  it "should load from json" do
    package = DataPackage::Package.load(tmpdir, json)

    package.path.should == tmpdir
    package.name.should == 'mypackage'
    package.title.should == 'Tells me about things'
    package.version.should == '0.0.1'

    package.resources.length.should == 1
    package.sources.length.should == 1
    package.licenses.length.should == 1
    package.maintainers.length.should == 1
    package.contributors.length.should == 1
  end

  it "should serialize to json" do
    package = DataPackage::Package.load(tmpdir, json)
    package.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end
end
