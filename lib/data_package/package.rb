require 'yajl'

module DataPackage
  class Package
    attr_accessor :path
    attr_accessor :name

    attr_accessor :title
    attr_accessor :version
    attr_accessor :description
    attr_accessor :last_modified
    attr_accessor :datapackage_version

    attr_accessor :sources
    attr_accessor :licenses
    attr_accessor :maintainers
    attr_accessor :contributors

    attr_accessor :resources

    # has_option :licenses, :from => 'licenses', :default => [],
    #   :serialize => lamda { |licenses| licenses.collect(&:to_hash) }

    def initialize(path, name, options = {})
      @path = path
      @name = name

      @title = options['title']
      @version = options['version']
      @description = options['description']
      @last_modified = options['last_modified']
      @datapackage_version = options['datapackage_version']

      @sources = options['sources'] || []
      @licenses = options['licenses'] || []
      @maintainers = options['maintainers'] || []
      @contributors = options['contributors'] || []

      @resources = options['resources'] || []
    end

    def to_hash
      {
        'name' => name,
        'title' => title,
        'version' => version,
        'description' => description,
        'last_modified' => last_modified,
        'datapackage_version' => datapackage_version,
        'sources' => sources.collect(&:to_hash),
        'licenses' => licenses.collect(&:to_hash),
        'maintainers' => maintainers.collect(&:to_hash),
        'contributors' => contributors.collect(&:to_hash),
        'resources' => resources.collect(&:to_hash)
      }.delete_if{ |k,v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      options = {:pretty => true}.merge(options)
      Yajl::Encoder.encode(to_hash, options)
    end

    def dump
      self.class.dump(self)
    end

    class << self
      def exist?(path)
        File.exist?(full_path(path))
      end
      
      def full_path(path)
        expanded = File.expand_path(path)
        File.join(expanded, 'datapackage.json')
      end

      def init(path, name)
        File.open(full_path(path), 'w+') do |file|
          file.write(Yajl::Encoder.encode({
            name: name,
            version: '0.0.1'
          }, :pretty => true))
        end

        open(path)
      end

      def open(path)
        full_path = full_path(path)
        expanded = File.expand_path(path)

        if File.exist?(full_path)
          file = File.open(full_path)
          load(path, Yajl::Parser.parse(file))
        else
          raise "Couldn't find datapackage.json at #{path}"
        end
      end

      def dump(package)
        File.open(full_path(package.path), 'w+') do |file|
          file.write(package.to_json(:pretty => true))
        end
      end

      def load(path, json)
        props = [
          'title', 'description', 'version',
          'last_modified', 'datapackage_version'
        ]

        options = json.select do |k, v|
          props.include?(k)
        end.delete_if{ |k, v| v.nil? }

        if json['sources']
          options['sources'] = build_sources(json['sources'])
        end

        if json['licenses']
          options['licenses'] = build_licenses(json['licenses'])
        end

        if json['maintainers']
          options['maintainers'] = build_maintainers(json['maintainers'])
        end

        if json['contributors']
          options['contributors'] = build_contributors(json['contributors'])
        end

        if json['resources']
          options['resources'] = build_resources(json['resources'], path)
        end

        new(path, json['name'], options)
      end

      private

      def build_resources(json, path)
        resources = []
        json.each do |resource|
          resources << Resource.load(resource, path)
        end
        resources
      end

      def build_sources(json)
        sources = []
        json.each do |source|
          sources << Source.load(source)
        end
        sources
      end

      def build_licenses(json)
        licenses = []
        json.each do |license|
          licenses << License.load(license)
        end
        licenses
      end

      def build_maintainers(json)
        maintainers = []
        json.each do |maintainer|
          maintainers << Person.load(maintainer)
        end
        maintainers
      end

      def build_contributors(json)
        contributors = []
        json.each do |contributor|
          contributors << Person.load(contributor)
        end
        contributors
      end
    end
  end
end