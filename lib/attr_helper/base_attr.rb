module AttrHelper
  class BaseAttr
    attr_reader :name
    attr_reader :key
    attr_reader :serialize

    def initialize(name, options = {})
      @name = name
      @key = options[:key] || name.to_s

      if options[:serialize] == false
        @serialize = false
      else
        @serialize = options[:serialize] || true
      end
    end

    def serializable?
      !@serialize.nil? && @serialize != false
    end

    def serialized(parent)
      if @serialize == true
        parent.send(name.to_sym)
      elsif @serialize.is_a?(Symbol)
        parent.send(@serialize)
      elsif serialize.is_a?(Proc)
        @serialize.call(parent)
      end
    end
  end
end