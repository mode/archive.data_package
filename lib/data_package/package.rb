module DataPackage
  class Package < Base
    attr_required :name

    attr_optional :path
    attr_optional :title
    attr_optional :version
    attr_optional :description
    attr_optional :datapackage_version

    attr_optional :sources, :serialize => Proc.new { |source|
      source && source.collect(&:to_hash)
    }
    
    attr_optional :licenses, :serialize => Proc.new { |licenses|
      licenses && licenses.collect(&:to_hash)
    }
    
    attr_optional :maintainers, :serialize => Proc.new { |maintainers|
      maintainers && maintainers.collect(&:to_hash)
    }

    attr_optional :contributors, :serialize => Proc.new { |contributors|
      contributors && contributors.collect(&:to_hash)
    }

    attr_optional :resources, :serialize => Proc.new { |resources|
      resources && resources.collect(&:to_hash)
    }

    attr_accessor :base_path

    def initialize(base_path, attrs = {})
      @base_path = base_path

      @resources ||= []
      @sources ||= []
      @licenses ||= []
      @maintainters ||= []
      @contributors ||= []

      super(attrs)
    end

    def save
      File.open(full_path, 'w+') do |file|
        file.write(self.to_json)
      end
    end

    def sources=(json)
      @sources = json.collect{|s| Source.new(s)}
    end

    def licenses=(json)
      @licenses = json.collect{|l| License.new(l)}
    end

    def maintainers=(json)
      @maintainers = json.collect{|m| Person.new(m)}
    end

    def contributors=(json)
      @contributors = json.collect{|c| Person.new(c)}
    end

    def resources=(json)
      @resources = json.collect{|r| Resource.new(base_path, r)}
    end

    private

    def full_path
      File.join(base_path, 'datapackage.json')
    end

    class << self
      def exist?(base_path)
        File.exist?(full_path(base_path))
      end
      
      def full_path(base_path)
        File.join(File.expand_path(base_path), 'datapackage.json')
      end

      def init(base_path, name)
        pkg = new(base_path, :name => name, :version => '0.0.1')
        pkg.save

        open(base_path)
      end

      def open(base_path)
        full_path = full_path(base_path)
        base_path = File.expand_path(base_path)

        if File.exist?(full_path)
          file = File.open(full_path)
          new(base_path, JSON.parse(File.read(file)))
        else
          raise "Couldn't find datapackage.json at #{path}"
        end
      end
    end
  end
end