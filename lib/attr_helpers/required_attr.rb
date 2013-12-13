module AttrHelpers
  class RequiredAttr
    attr_reader :name

    attr_reader :key
    attr_reader :serialize

    def initialize(name, options = {})
      @name = name
      @key = options[:key] || name.to_s
      @serialize = options[:serialize] || true

      @_if = options[:if]
      @_unless = options[:unless]
    end

    def required?(parent = nil)
      if @_if.nil? || parent.nil?
        true
      elsif @_if.is_a?(Symbol)
        parent.send(@_if)
      else
        @_if.call(parent) && !excluded?(parent)
      end
    end

    private

    def excluded?(parent)
      if @_unless.nil?
        false
      elsif @_unless.is_a?(Symbol)
        parent.send(@_unless)
      else
        @_unless.call(parent)
      end
    end
  end
end