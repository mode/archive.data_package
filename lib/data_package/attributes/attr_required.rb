#
# attr_required :name
# attr_required :path, :if => lamda {|obj
#   obj.attr_missing?(:url) && obj.attr_missing?(:data)
# }
#
# attr_optional :title
#
# attr_optional :sources, :default => [], :keys => ['sources']
#   :serialize => lambda { |source| source.collect(&:to_hash) }

# keys not required by default for attr_optional, defaults to name of the attribute

#
# Instance Methods
# required_attrs => [...]
# optional_attrs => [...]
# serializable_attrs => [...]
# valid? => are all required fields present?
# attr_required?(attr_name) #=> boolean
# attr_missing?(attr_name) #=> boolean
# attr_present?(attr_name) #=> boolean
# to_hash => serialize all serializable fields
# to_json => encode the to_hash stuff
#
module Mode
  module AttrRequired
    class AttrMissing < StandardError; end

    def self.included(klass)
      klass.send :extend, ClassMethods
    end

    module ClassMethods
      def inherited(klass)
        super

        unless required_attributes.empty?
          klass.attr_required *required_attributes
        end
      end

      def attr_required(name, options = {})
        attr_accessor name
        required_attributes << DataPackage::Attr.new(name, options)
      end
    end

    def required_attributes
      @required_attributes ||= []
    end

    def attr_required?(name)
      attr = required_attributes.find do |attr|
        attr.name == name && attr.included?
      end
      
      if attr
      else
        false
      end
    end

    def attr_missing?
      !attr_missing.empty?
    end

    def attr_missing
      required_attributes.select do |name|
        value = send(name)
        if value.respond_to?(:empty?)
          value.empty?
        else
          value.nil?
        end
      end
    end
  end
end

#
# gem 'data_package'
#
# require 'data_package'
#
# DataPackage::Package.new(...)
# DataPackage::Builder.new
# DataPackage::Compressor.new
#