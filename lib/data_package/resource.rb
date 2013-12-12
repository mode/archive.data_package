require 'yajl'
require 'data_kit'

module DataPackage
  class Resource

    attr_accessor :schema
    attr_accessor :dialect

    attr_accessor :name
    attr_accessor :format
    attr_accessor :media_type
    attr_accessor :path

    attr_accessor :size
    attr_accessor :md5hash
    attr_accessor :last_modified

    attr_accessor :base_path

    def initialize(schema, options = {})
      @schema = schema
      @dialect = options['dialect']

      @name = options['name']
      @format = options['format'] || 'csv'
      @path = options['path'] || 'data.csv'
      # TODO allow for URLs or inline data here

      @media_type = options['mediatype']
      @size = options['bytes'] || options['size']
      @md5hash = options['hash'] || options['md5hash']
      @last_modified = options['modified'] || options['lastModified']

      @base_path = options['base_path'] || File.expand_path('.')
    end

    def full_path
      File.join(base_path, path)
    end

    def to_hash
      {
        'name' => name,
        'format' => format,
        'mediatype' => media_type,
        'path' => path,
        'bytes' => size,
        'hash' => md5hash,
        'modified' => last_modified,
        'dialect' => (dialect && dialect.to_hash),
        'schema' => schema.to_hash
      }.delete_if{ |k, v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      options = {:pretty => true}.merge(options)
      Yajl::Encoder.encode(to_hash, options)
    end

    def each_row(&block)
      case format
      when 'csv'
        opts = {'dialect' => dialect}
        parser = DataKit::CSV::Parser.new(full_path, opts)
        parser.each_row(schema.parser_columns, &block)
      else
        raise "Unrecognized resource format #{format} for resource #{name}."
      end
    end

    class << self
      def load(json, base_path = '.')
        if json.nil?
          raise "Invalid resource format"
        end

        unless json['schema']
          raise "Schema not found for resource #{json['name']}"
        end
        
        options = {
          'name' => json['name'],
          'format' => json['format'],
          'mediatype' => json['mediatype'],
          'path' => json['path'],
          'size' => json['bytes'] || json['size'],
          'md5hash' => json['hash'] || json['md5hash'],
          'lastModified' => json['modified'] || json['lastModified'],
          'base_path' => base_path
        }.delete_if{ |k, v| v.nil? || v.empty? }


        if json['dialect']
          options['dialect'] = Dialect.load(json['dialect'])
        end

        schema = Schema.load(json['schema'])

        new(schema, options)
      end

      def build(schema, path, options = {})
        new(schema, options.merge({'path' => path}))
      end
    end
  end
end