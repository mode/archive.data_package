module AttrHelpers
  module Assignment
    def write_attributes(attrs = {})
      required_attributes.each do |attribute|
        self.instance_variable_set("@#{attribute.name}", attrs[attribute.key.to_sym])
      end
    end
  end
end