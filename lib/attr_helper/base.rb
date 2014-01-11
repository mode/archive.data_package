require 'attr_helper/base_attr'
require 'attr_helper/required_attr'
require 'attr_helper/serialization'

module AttrHelper
  module Base
    def self.included(klass)
      klass.send :extend, ClassMethods
    end

    module ClassMethods
      def inherited(klass)
        super

        # we might want to undef here so
        #  that child classes can override

        unless required_attributes.empty?
          add_required_attrs(klass)
        end

        unless optional_attributes.empty?
          add_optional_attrs(klass)
        end
      end

      def attr_optional(name, options = {})
        optional_attributes << BaseAttr.new(name.to_sym, options)
        attr_accessor name.to_sym
      end

      def optional_attributes
        @optional_attributes ||= []
      end

      def attr_required(name, options = {})
        required_attributes << RequiredAttr.new(name.to_sym, options)
        attr_accessor name.to_sym
      end

      def required_attributes
        @required_attributes ||= []
      end

      private

      def add_required_attrs(klass)
        required_attributes.each do |attribute|
          klass.attr_required attribute.name, {
            :name => attribute.name,
            :key => attribute.key,
            :default => attribute.default,
            :serialize => attribute.serialize,
            :if => attribute.if_cond,
            :unless => attribute.unless_cond
          }
        end
      end

      def add_optional_attrs(klass)
        optional_attributes.each do |attribute|
          klass.attr_optional attribute.name, {
            :name => attribute.name,
            :key => attribute.key,
            :default => attribute.default,
            :serialize => attribute.serialize
          }
        end
      end
    end

    def required_attributes
      self.class.required_attributes
    end
    
    def optional_attributes
      self.class.optional_attributes
    end

    def attributes
      required_attributes + optional_attributes
    end

    def missing_attributes
      required_attributes.select do |attribute|
        attribute.required?(self)
      end.select do |attribute|
        value = send(attribute.name)
        value.respond_to?(:empty?) ? value.empty? : value.nil?
      end
    end

    def attr_required?(name)
      required_attributes.any?{|a| a.name == name}
    end

    def attr_missing?(name)
      missing_attributes.any?{|a| a.name == name}
    end

    def attr_present?(name)
      !attr_missing?(name)
    end

    def write_attribute(name, value)
      self.instance_variable_set("@#{name}", value)
    end

    def write_attributes(attrs = {})
      attrs = DataPackage::Helpers.symbolize_keys(attrs)
      
      attributes.each do |attribute|
        value = attrs[attribute.key.to_sym] || attribute.default
        self.send("#{attribute.name}=", value) unless value.nil?
      end
    end
  end
end