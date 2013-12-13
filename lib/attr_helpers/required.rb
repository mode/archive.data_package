module AttrHelpers
  module Required
    class AttrMissing < StandardError; end

    def self.included(klass)
      klass.send :extend, ClassMethods
    end

    module ClassMethods
      def inherited(klass)
        super

        unless required_attributes.empty?
          required_attributes.each do |attribute|
            klass.attr_required attribute.name, {
              :name => attribute.name,
              :key => attribute.key,
              :if => attribute.if_cond,
              :unless => attribute.unless_cond,
              :serialize => attribute.serialize
            }
          end
        end
      end

      def attr_required(name, options = {})
        required_attributes << RequiredAttr.new(name.to_sym, options)
        attr_accessor name.to_sym
      end

      def required_attributes
        @required_attributes ||= []
      end
    end

    def required_attributes
      self.class.required_attributes.select do |attribute|
        attribute.required?(self)
      end
    end

    def missing_attributes
      required_attributes.select do |attribute|
        value = send(attribute.name)
        value.respond_to?(:empty?) ? value.empty? : value.nil?
      end
    end

    def attr_required?(name)
      required_attributes.find{|a| a.name == name} != nil
    end

    def attr_missing?(name)
      missing_attributes.find{|a| a.name == name} != nil
    end

    def attr_present?(name)
      !attr_missing?(name)
    end
  end
end