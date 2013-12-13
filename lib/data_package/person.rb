module DataPackage
  class Person < Base
    attr_optional :name
    attr_optional :email
    attr_optional :web
  end
end