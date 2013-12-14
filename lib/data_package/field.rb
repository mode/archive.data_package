module DataPackage
  class Field < Base
    Types = Set.new([
      :any, :string, :number, :integer,
      :date, :time, :datetime, :boolean, :binary,
      :object, :geopoint, :geojson, :array
    ])

    attr_required :name
    attr_optional :title
    attr_optional :description
    attr_optional :type, :default => :string,
      :serialize => Proc.new{ |type| type && type.to_s }
    attr_optional :format

    def type=(value)
      write_attribute(:type, value.to_sym)
    end
  end
end