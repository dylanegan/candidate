module Candidate
  class Manifest
    def initialize(attributes, connection)
      @attributes = attributes
      @connection = connection
    end

    def fork(fork_name)
      @connection.fork_manifest(name, fork_name)
    end

    def id
      @attributes[:id]
    end

    def name
      @attributes[:name]
    end

    def release(components)
      @connection.create_release(name, components)
    end

    def releases
      @releases ||= @connection.releases(name)
    end

    def components
      @components ||= releases.last.components
    end

    def [](key)
      components[key]
    end

    def []=(key, value)
      components[key] = value
    end

    def destroy
      @connection.destroy_manifest(name)
    end
  end
end
