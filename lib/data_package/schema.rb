module DataPackage
  class Schema < Base
    attr_required :fields, :serialize => Proc.new { |fields|
      fields.collect(&:to_hash)
    }

    attr_optional :primary_key, :key => 'primaryKey'

    def fields=(json)
      @fields = json.collect{|f| Field.new(f)}
    end
  end
end