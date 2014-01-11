require 'yajl'

module AttrHelper
  module Serialization
    def to_hash
      {}.tap do |hsh|
        attributes.each do |attribute|
          next unless attribute.serializable?
          
          value = attribute.serialized(self)

          if value.respond_to?(:empty?)
            hsh[attribute.key] = value unless value.empty?
          else
            hsh[attribute.key] = value unless value.nil?
          end
        end
      end
    end

    def to_json(options = {})
      options = {:pretty => true}.merge(options)
      Yajl::Encoder.encode(to_hash, options)
    end
  end
end