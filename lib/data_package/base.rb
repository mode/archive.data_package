module DataPackage
  class Base
    include AttrHelper

    def initialize(attrs = {})
      write_attributes(attrs)
    end
  end
end