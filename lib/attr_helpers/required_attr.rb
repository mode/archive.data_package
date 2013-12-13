module AttrHelpers
  class RequiredAttr
    attr_reader :name

    attr_reader :key
    attr_reader :serialize

    attr_reader :if_cond
    attr_reader :unless_cond

    def initialize(name, options = {})
      @name = name
      @key = options[:key] || name.to_s
      @serialize = options[:serialize] || true

      @if_cond = options[:if]
      @unless_cond = options[:unless]
    end

    def required?(parent)
      if conditions_empty?
        true
      else
        included?(parent) && !excluded?(parent)
      end
    end

    private

    def conditions_empty?
      if_cond.nil? && unless_cond.nil?
    end

    def included?(parent)
      if if_cond.nil?
        true
      elsif if_cond.is_a?(Symbol)
        parent.send(if_cond)
      else
        if_cond.call(parent)
      end
    end

    def excluded?(parent)
      if unless_cond.nil?
        false
      elsif unless_cond.is_a?(Symbol)
        parent.send(unless_cond)
      else
        unless_cond.call(parent)
      end
    end
  end
end