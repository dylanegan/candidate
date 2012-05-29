require 'rest-client'
require 'json'

module Candidate
  module S3
    def self.components
      @data ||= Hash.new do |hash, manifest|
        hash[manifest] = Hash.new do |manifest_hash, version|
          manifest_hash[version] = {}
        end
      end
    end

    def self.mock!
      @mock = true
    end

    def self.mocking?
      @mock
    end

    def self.reset!
      @data = nil
    end

    def self.new(app_name, manifest_name)
      Connection.new(app_name, manifest_name)
    end

    def self.url_for(app_name, manifest_name, version)
      "https://#{app_name}.s3.amazonaws.com/#{manifest_name}-#{version}.json"
    end

    class Connection
      def initialize(app_name, manifest_name)
        @app_name = app_name
        @manifest_name = manifest_name
      end

      def current
        get('current')
      end

      def get(version)
        components = if S3.mocking?
                       if S3.components.has_key?(@manifest_name)
                         S3.components[@manifest_name][version]
                       else
                         raise RestClient::ResourceNotFound
                       end
                     else
                       JSON.parse(RestClient.get(url(version)))
                     end
        Manifest.new components
      end

      def url(version)
        S3.url_for(@app_name, @manifest_name, version)
      end
    end

    class Manifest
      attr_reader :components
      def initialize(components)
        @components = components
      end

      def [](component)
        @components[component]
      end

      def []=(component, version)
        @components[component] = version
      end
    end
  end
end
