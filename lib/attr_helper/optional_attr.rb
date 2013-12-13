module AttrHelper
  class OptionalAttr
    attr_reader :name
    attr_reader :key
    attr_reader :serialize

    def initialize(name, options = {})
      @name = name
      @key = options[:key] || name.to_s
      @serialize = options[:serialize] || true
    end
  end
end