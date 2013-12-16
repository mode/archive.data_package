require 'spec_helper'

describe DataPackage::Package do
  let(:tmpdir) {
    Dir.mktmpdir
  }

  it "should init" do
    package = DataPackage::Package.init(tmpdir, 'mypackage')

    package.name.should == 'mypackage'
    package.version.should == '0.0.1'
    package.resources.should == nil
    package.base_path.should == tmpdir
  end

  it "should raise on open if the package file doesn't exist" do
    expect { package = DataPackage::Package.open(tmpdir) }.to raise_error
  end

  it "should check if a package exists" do
    package_path = File.join(base_path, 'package')
    DataPackage::Package.exist?(package_path).should == true
  end

  it "should initialize and serialize" do
    package_path = File.join(base_path, 'package')
    package = DataPackage::Package.open(package_path)

    package.name.should == 'standard'
    package.title.should == 'Standard Data Package'
    package.version.should == '0.0.1'

    package.resources.length.should == 1

    # Did schema d
    package.resources.first.schema.fields.length.should == 10
    package.resources.first.schema.primary_key.should == ['id']

    package.sources.length.should == 1
    package.licenses.length.should == 1
    package.maintainers.length.should == 1
    package.contributors.length.should == 1
  end

  # it "should serialize to json" do
  #   package = DataPackage::Package.load(tmpdir, json)
  #   package.to_json.should == Yajl::Encoder.encode(json, :pretty => true)
  # end
end
