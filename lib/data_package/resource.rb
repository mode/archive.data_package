require 'data_kit'

module DataPackage
  class Resource < Base    
    attr_optional :name

    attr_required :data,
      :if => Proc.new{ |resource| resource.path.nil? && resource.url.nil?  }

    attr_required :path,
      :if => Proc.new{ |resource| resource.data.nil? && resource.url.nil?  }
    
    attr_required :url,
      :if => Proc.new{ |resource| resource.data.nil? && resource.path.nil? }

    attr_required :schema, :serialize => Proc.new { |schema| schema.to_hash }
    attr_optional :dialect, :serialize => Proc.new { |dialect| dialect.to_hash }

    attr_optional :format, :default => 'csv'
    attr_optional :media_type, :key => 'mediaType'

    attr_optional :size
    attr_optional :hash
    attr_optional :last_modified, :key => 'lastModified'

    attr_accessor :base_path

    def initialize(base_path, attrs = {})
      @base_path = base_path
      super(attrs)
    end

    def schema=(json)
      @schema = Schema.new(json)
    end

    def dialect=(json)
      @dialect = Dialect.new(json)
    end

    def each_row(&block)
      case data_source_type
      when :data
        data.each(&block)
      when :path
        case format
        when 'csv'
          opts = {'dialect' => dialect}
          DataKit::CSV::Parser.new(full_path, opts).each_row(&block)
        else
          raise "Unrecognized resource format #{format} for resource #{name}."
        end
      when :url
        raise "URL based resources are not yet supported"
      else
        raise "Resources require one of data, path or url keys to be specified"
      end
    end

    private

    def full_path
      File.join(base_path, path)
    end

    def data_source_type
      if data
        :data
      elsif path
        :path
      elsif url
        :url
      end
    end
  end
end