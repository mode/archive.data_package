require 'yajl'

module DataPackage
  class Field
    Types = Set.new([
      :any, :string, :number, :integer,
      :date, :time, :datetime, :boolean, :binary,
      :object, :geopoint, :geojson, :array
    ])

    attr_accessor :name
    attr_accessor :type

    attr_accessor :title
    attr_accessor :description
    attr_accessor :format

    def initialize(name, type = :string, options = {})
      @name = name
      @type = type.to_sym

      @title = options['title']
      @description = options['description']
      @format = options['format']
    end

    def to_hash
      {
        'name' => name,
        'type' => type,
        'title' => title,
        'description' => description,
        'format' => format
      }.delete_if { |k, v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      Yajl::Encoder.encode(to_hash,
        {:pretty => true}.merge(options))
    end

    def ==(other)
      return !other.nil? &&
        self.name == other.name &&
        self.type == other.type &&
        self.title == other.title &&
        self.description == other.description &&
        self.format == other.format
    end

    class << self
      def load(json)
        if json.nil?
          raise "Invalid field format"
        end

        options = {
          'title' => json['title'],
          'description' => json['description'],
          'format' => json['format']
        }.delete_if { |k, v| v.nil? || v.empty? }

        new(json['name'], json['type'], options)
      end
    end
  end
end