module Tatooine
  module Resource
    MAPPING = {
      "films" => :Film,
      "people" => :Person,
      "planets" => :Planet,
      "species" => :Species,
      "starships" => :Starship,
      "vehicles" => :Vehicle,
      "homeworld" => :Planet,
      "characters" => :Person,
      "pilots" => :Person,
      "residents" => :Person
    }

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(opts={})
      @properties = opts
      set_properties
    end

    private

    def set_properties
      self.class.schema["properties"].each do |property, values|
        properties = @properties.dup
        if properties[property]
          if values["type"] == "integer"
            properties[property] = properties[property].to_i
          elsif values["type"] == "array" && MAPPING.keys.include?(property)
            klass = Tatooine.const_get(MAPPING[property])
            properties[property] = properties[property].map do |url|
              klass.new("url" => url)
            end
          elsif MAPPING.keys.include?(property)
            klass = Tatooine.const_get(MAPPING[property])
            properties[property] = klass.new("url" => properties[property])
          end
          instance_variable_set("@#{property}", properties[property])
        end
      end
      @url = @properties["url"] if @properties["url"]
    end


    module ClassMethods
      def list(opts={})
        load_schema
        url = opts.delete("url") || ""
        body = connection.get(url, opts).body
        @count = body["count"]
        @next = body["next"]
        @previous = body["previous"]
        body["results"].map { |result| new(result) }
      end

      def count
        @count || get_count
      end

      def next
        list "url" => @next if @next
      end

      def previous
        list "url" => @previous if @previous
      end

      def get(id)
        load_schema
        result = connection.get("#{id}/")
        new(result.body)
      end

      def schema
        load_schema
      end

      def connection
        options = {
          :headers => {
            "User-Agent" => "Tatooine Ruby Gem - #{Tatooine::VERSION}"
          },
          :url => "#{Tatooine::API_BASE}#{@resource_path}/"
        }
        @connection ||= Faraday.new(options) do |faraday|
          faraday.response :raise_http_error
          faraday.response :dates
          faraday.response :json
          faraday.adapter  Faraday.default_adapter
        end
      end

      private

      def load_schema
        if !@schema
          @schema = connection.get("schema").body
          @schema["properties"].keys.each do |property|
            define_method property.to_sym do
              if @properties.nil? || @properties.keys.length <= 1
                result = self.class.connection.get(@url)
                @properties = result.body
                set_properties
              end
              instance_variable_get("@#{property}")
            end
          end
        end
        @schema
      end

      def get_count
        @count = connection.get("").body["count"]
      end

      def resource_path(path)
        @resource_path = path
      end
    end
  end
end
