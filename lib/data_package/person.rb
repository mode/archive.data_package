require 'yajl'

module DataPackage
  class Person
    attr_accessor :name
    attr_accessor :email
    attr_accessor :web

    def initialize(name, options = {})
      @name = name
      @email = options['email']
      @web = options['web']
    end

    def to_hash
      {
        'name' => name,
        'email' => email,
        'web' => web
      }.delete_if { |k, v| v.nil? || v.empty? }
    end

    def to_json(options = {})
      Yajl::Encoder.encode(to_hash,
        {:pretty => true}.merge(options))
    end

    def ==(other)
      return !other.nil? &&
        self.name == other.name &&
        self.email == other.email &&
        self.web == other.web
    end

    class << self
      def load(json)
        if json.nil?
          raise "Invalid person format"
        end

        options = {
          'email' => json['email'],
          'web' => json['web']
        }.delete_if { |k, v| v.nil? || v.empty? }

        new(json['name'], options)
      end
    end
  end
end