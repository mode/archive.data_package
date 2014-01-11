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
    attr_optional :dialect, :serialize => Proc.new { |dialect| dialect && dialect.to_hash }

    attr_optional :format, :default => 'csv'
    attr_optional :media_type, :key => 'mediaType'

    attr_optional :size
    attr_optional :hash

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

    #
    # Future Note:
    #   For remote resources we should have a path *and* a url
    #   If the path is a file on disk then use it, otherwise assume
    #   that the path is a pointer to the destination of the URL data
    #   this makes it possible for scripts to rely on a file location
    #

    def each_row(&block)
      case data_source_type
      when :data
        data.each(&block)
      when :path
        file_path = File.join(base_path, path)
        
        case format
        when 'csv'
          DataKit::CSV::Parser.new(file_path).each_row(&block)
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