module DataPackage
  class Base
    include AttrHelper::Base
    include AttrHelper::Serialization

    def initialize(attrs = {})
      write_attributes(attrs)
    end
  end
end