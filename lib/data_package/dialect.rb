module DataPackage
  class Dialect < Base
    attr_optional :delimiter, :default => ','
    attr_optional :double_quote, :key => 'doublequote', :default => false
    attr_optional :line_terminator, :key => 'lineterminator', :default => "\n"
    attr_optional :quote_char, :key => 'quotechar', :default => "\""
    attr_optional :skip_initial_space, :key => 'skipinitialspace', :default => false
  end
end