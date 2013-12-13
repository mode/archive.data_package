module AttrHelpers
  module Assignment
    def write_attribute(name, value)
      self.instance_variable_set("@#{name}", value)
    end

    def write_attributes(attrs = {})
      required_attributes.each do |attribute|
        # does this bypass custom setters?
        self.send("#{attribute.name}=", attrs[attribute.key.to_sym])
      end
    end
  end
end