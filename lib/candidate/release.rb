module Candidate
  class Release
    def initialize(attributes, connection)
      @attributes = attributes
      @connection = connection
    end

    def components
      @attributes[:components]
    end

    def diff
      @attributes[:diff]
    end

    def manifest
      @manifest ||= @connection.manifest(manifest_name)
    end

    def manifest_id
      @attributes[:manifest_id]
    end

    def manifest_name
      @attributes[:manifest_name]
    end

    def s3_url
      "https://#{@connection.app_name}.s3.amazonaws.com/#{manifest.name}-#{version}.json"
    end

    def version
      @attributes[:version]
    end
  end
end
