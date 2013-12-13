require 'json'

module AttrHelper
  module Serialization
    def to_json
      json = {}
      attributes.each do |attribute|
        if attribute.serializable?
          value = attribute.serialized(self)

          if value.respond_to?(:empty?)
            json[attribute.key] = value unless value.empty?
          else
            json[attribute.key] = value unless value.nil?
          end
        end
      end
      JSON.generate(json)
    end
  end
end