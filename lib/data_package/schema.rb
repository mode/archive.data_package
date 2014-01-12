module DataPackage
  class Schema < Base
    attr_required :fields, :serialize => Proc.new { |fields|
      fields.collect(&:to_hash)
    }

    attr_optional :primary_key, :key => 'primaryKey',
      :serialize => Proc.new{|pkey| pkey.length == 1 ? pkey.first : pkey }

    def initialize(attrs = {})
      @fields ||= []
      
      super(attrs)
    end

    def fields=(json)
      @fields = json.collect{|f| Field.new(f)}
    end

    def primary_key=(json)
      if json.is_a?(Array)
        @primary_key = json
      else
        @primary_key = [json]
      end
    end
  end
end