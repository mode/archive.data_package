module Mode
  class Attr
    attr_accessor :name
    attr_accessor :ifblk
    attr_accessor :unlessblk

    attr_accessor :keys
    attr_accessor :default
    attr_accessor :serialize

    def initialize(name, options = {})
      @name = name
      
      @ifblk = options[:if]
      @unlessblk = options[:unless]

      @keys = options[:keys]
      @default = options[:default]
      @serialize = options[:serialize]
    end

    def included?(parent)
      if ifblk.nil?
        true
      else
        ifblk.call(parent) && !excluded?(parent)
      end
    end

    private

    def excluded?(parent)
      if unlessblk.nil?
        false
      else
        unlessblk.call(parent)
      end
    end
  end
end