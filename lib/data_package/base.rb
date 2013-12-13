module DataPackage
  class Base
    include AttrHelper
    include AttrHelper::Serialization

    def initialize(attrs = {})
      write_attributes(attrs)
    end
  end
end