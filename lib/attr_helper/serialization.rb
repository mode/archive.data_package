require 'json'

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
      if options[:pretty].nil? || options[:pretty]
        JSON.pretty_generate(to_hash)
      else
        JSON.generate(to_hash)
      end
    end
  end
end