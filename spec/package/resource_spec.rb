require 'spec_helper'

describe DataPackage::Resource do
  let(:json) {
    {
      "name" => "mydataset",
      "format" => "csv",
      "path" => "data.csv",

      "dialect" => {
        "delimiter" => "\t",
        "doublequote" => false,
        "lineterminator" => "\n",
        "quotechar" => "\"",
        "skipinitialspace" => false
      },

      'schema' => {
        'fields' => [
          {
            'name' => 'income',
            'type' => 'number'
          }
        ],

        'primaryKey' => ['income']
      }
    }
  }

  let(:espn_json) {
    {
      "name" => "espn_draft",
      "title" => "ESPN Draft Picks",
      "format" => "csv",
      "path" => "espn_draft.csv",

      "dialect" => {
        "delimiter" => ",",
        "doublequote" => false,
        "lineterminator" => "\n",
        "quotechar" => "\"",
        "skipinitialspace" => false
      },

      'schema' => {
        'fields' => [
          {
            'name' => 'draft_order',
            'type' => 'string'
          },
          {
            'name' => 'player',
            'type' => 'string'
          },
          {
            'name' => 'position',
            'type' => 'string'
          },
          {
            'name' => 'avg_draft_position',
            'type' => 'number'
          },
          {
            'name' => 'avg_bid_value',
            'type' => 'number'
          }
        ],

        'primaryKey' => ['player']
      }
    }
  }

  it "should load from json" do
    resource = DataPackage::Resource.load(json)

    resource.name.should == 'mydataset'
    resource.format.should == 'csv'
    resource.path.should == 'data.csv'

    resource.dialect.delimiter.should == "\t"

    resource.schema.fields[0].name.should == 'income'
    resource.schema.primary_key.should == ['income']
  end

  it "should serialize to json" do
    resource = DataPackage::Resource.load(json)
    resource.to_json(:pretty => true).should == Yajl::Encoder.encode(json, :pretty => true)
  end

  it "should iterate over each row" do
    tmpdir = Dir.mktmpdir
    FileUtils.cp(csv_path('espn_draft.csv'), File.join(tmpdir, 'espn_draft.csv'))
    
    resource = DataPackage::Resource.load(espn_json, tmpdir)

    resource.base_path.should == tmpdir

    row_count = 0
    resource.each_row do |row|
      row_count += 1
    end
    row_count.should == 472
  end
end