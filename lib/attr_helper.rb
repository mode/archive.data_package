require 'attr_helper/optional_attr'
require 'attr_helper/required_attr'

module AttrHelper
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

      unless optional_attributes.empty?
        optional_attributes.each do |attribute|
          klass.attr_optional attribute.name, {
            :name => attribute.name,
            :key => attribute.key,
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

    def attr_optional(name, options = {})
      optional_attributes << OptionalAttr.new(name.to_sym, options)
      attr_accessor name.to_sym
    end

    def optional_attributes
      @optional_attributes ||= []
    end
  end

  def attributes
    required_attributes + optional_attributes
  end

  def required_attributes
    self.class.required_attributes.select do |attribute|
      attribute.required?(self)
    end
  end
  
  def optional_attributes
    self.class.optional_attributes
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

  def write_attribute(name, value)
    self.instance_variable_set("@#{name}", value)
  end

  def write_attributes(attrs = {})
    attributes.each do |attribute|
      self.send("#{attribute.name}=", attrs[attribute.key.to_sym])
    end
  end
end