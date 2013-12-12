require 'yajl'

module DataPackage
  class Dialect

    attr_accessor :delimiter
    attr_accessor :double_quote
    attr_accessor :line_terminator
    attr_accessor :quote_char
    attr_accessor :skip_initial_space

    def initialize(options = {})
      @delimiter = options['delimiter'] || ','
      @double_quote = options['doublequote'] || false
      @line_terminator = options['lineterminator'] || "\n"
      @quote_char = options['quotechar'] || "\""
      @skip_initial_space = options['skipinitialspace'] || false
    end

    def to_hash
      {
        'delimiter' => delimiter,
        'doublequote' => double_quote,
        'lineterminator' => line_terminator,
        'quotechar' => quote_char,
        'skipinitialspace' => skip_initial_space
      }.delete_if { |k, v| v.nil? || (!is_boolean?(v) && v.empty?) }
    end

    def to_json(options = {})
      options = {:pretty => true}.merge(options)

      Yajl::Encoder.encode(to_hash, options)
    end
    
    class << self
      def load(json)
        if json.nil?
          raise "Invalid dialect format"
        end

        new(json)
      end
    end
    
    private
      def is_boolean?(value)
        !!value == value
      end
  end
end