require 'spec_helper'

describe DataPackage::Package do
  let(:tmpdir) {
    Dir.mktmpdir
  }

  let(:package_path) {
    File.join(base_path, 'package')
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
    DataPackage::Package.exist?(package_path).should == true
  end

  it "should initialize and serialize" do
    package = DataPackage::Package.open(package_path)

    package.name.should == 'standard'
    package.title.should == 'Standard Data Package'
    package.version.should == '0.0.1'

    package.resources.length.should == 1

    package.resources.first.schema.fields.length.should == 10
    package.resources.first.schema.primary_key.should == ['id']
    package.resources.first.base_path.should == package.base_path

    package.sources.length.should == 1
    package.licenses.length.should == 1
    package.maintainers.length.should == 1
    package.contributors.length.should == 1
  end

  it "should save the package" do
    package = DataPackage::Package.open(package_path)

    package.base_path = tmpdir
    package.name = "tested_package"

    package.save

    reopened = DataPackage::Package.open(tmpdir)

    reopened.name.should == "tested_package"
  end
end
