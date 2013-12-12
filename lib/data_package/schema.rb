require 'yajl'

module DataPackage
  class Schema
    attr_accessor :fields
    attr_accessor :primary_key

    def initialize(fields, options = {})
      @fields = fields || []
      @primary_key = options[:primary_key] || []
    end

    def to_hash
      {
        'fields' => fields.collect(&:to_hash),
        'primaryKey' => primary_key,
      }.delete_if{ |k, v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      Yajl::Encoder.encode(to_hash,
        {:pretty => true}.merge(options))
    end

    def parser_columns
      columns = {}
      fields.each_with_index do |field, index|
        columns[index] = { :alias => field.name }
      end
      columns
    end

    class << self
      def load(json)
        if json.nil?
          raise "Invalid schema format"
        end

        options = {}
        if json['primaryKey']
          options[:primary_key] = json['primaryKey']
        end

        fields = []
        json['fields'].each do |field|
          fields << Field.load(field)
        end

        new(fields, options)
      end
    end
  end
end