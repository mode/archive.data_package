require 'spec_helper'
require 'resource_helper'

describe DataPackage::Resource do
  it "should initialize and serialize" do    
    resource = DataPackage::Resource.new(base_path, standard_resource)

    resource.format.should == 'csv'
    resource.name.should == 'standard'
    resource.path.should == 'standard.csv'

    resource.schema.fields.length.should == 10
    resource.schema.primary_key.should == ['id']

    modified_resource = standard_resource.merge(
      'format' => 'csv',
      'dialect' => DataPackage::Dialect.new.to_hash,
      'schema' => standard_resource['schema'].merge(
        'primaryKey' => 'id'
      )
    )

    resource.to_hash.should == modified_resource
  end

  it "should initialize and deserialize a remote resource" do
    resource = DataPackage::Resource.new(base_path, remote_resource)

    resource.format.should == 'csv'
    resource.name.should == 'country-codes'
    resource.path.should == 'data/country-codes.csv'
    resource.url.should ==  'https://datahub.com/datasets/country-codes.csv'

    resource.schema.fields.length.should == 3
    resource.schema.primary_key.should == ['id']

    modified_resource = remote_resource.merge(
      'format' => 'csv',
      'schema' => remote_resource['schema'].merge(
        'primaryKey' => 'id'
      )
    )

    resource.to_hash.should == modified_resource.merge('format' => 'csv')
  end

  describe "#each_row" do
    it "should enumerate over inline data" do
      resource = DataPackage::Resource.new(base_path, inline_resource)

      row_count = 0
      resource.each_row do |row|
        row_count += 1
      end
      row_count.should == 3
    end

    it "should enumerate over local file data" do
      resource = DataPackage::Resource.new(base_path, standard_resource)

      row_count = 0
      resource.each_row { |row| row_count += 1 }
      row_count.should == 10
    end

    it "should not enumerate URL data" do
      resource = DataPackage::Resource.new(base_path, http_resource)
      expect{ resource.each_row{|row| nil} }.to raise_error
    end

    it "should raise if the data format is unexpected" do
      resource = DataPackage::Resource.new(base_path, standard_resource.merge('format' => 'unknown'))
      expect{ resource.each_row{|row| nil} }.to raise_error
    end

    it "should raise if data, path or url aren't present" do
      invalid = standard_resource.dup
      invalid.delete('path')

      resource = DataPackage::Resource.new(base_path, invalid)
      expect{ resource.each_row{|row| nil} }.to raise_error
    end
  end
end