require 'yajl'

module DataPackage
  class License
    attr_accessor :id
    attr_accessor :url

    def initialize(options = {})
      @id = options['id']
      @url = options['url']
    end

    def to_hash
      {
        'id' => id,
        'url' => url
      }.delete_if { |k, v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      Yajl::Encoder.encode(to_hash,
        {:pretty => true}.merge(options))
    end

    def ==(other)
      return !other.nil? &&
        self.id == other.id &&
        self.url == other.url
    end

    class << self
      def load(json)
        if json.nil?
          raise "Invalid license format"
        end

        options = {
          'id' => json['id'],
          'url' => json['url']
        }.delete_if { |k, v| v.nil? || v.empty? }

        new(options)
      end
    end
  end
end