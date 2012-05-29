require 'uri'
require 'rest-client'
require 'multi_json'

module URI
  class Generic
    def to_s_without_extras
      old_user, old_password, old_fragment = @user, @password, @fragment
      @user, @password, @fragment = [nil] * 3
      result = to_s
      @user, @password, @fragment = old_user, old_password, old_fragment
      result
    end
  end
end

module Candidate::Backends
  class HTTP
    def initialize(uri)
      @uri = uri
    end

    def destroy_manifest(name)
      json_delete("/manifests/#{name}")
    end

    def fork_manifest(name, fork_name)
      json_post("/manifests/#{name}/fork", { name: fork_name })
    end

    def manifest(name)
      json_get("/manifests/#{name}.json")
    end

    def manifests
      json_get("/manifests.json")
    end

    def create_release(manifest, components)
      json_post("/manifests/#{manifest}/release", components)
    end

    def releases(manifest)
      json_get("/manifests/#{manifest}/releases.json")
    end

    private

    def json_get(path)
      body = get(path, :accept => "application/json")
      MultiJson.decode(body, :symbolize_keys => true)
    end

    def get(path, options = {})
      connection[path].get(options)
    end

    def json_delete(path)
      delete(path, :accept => "application/json")
    end

    def delete(path, options = {})
      connection[path].delete(options)
    end

    def json_post(path, data)
      body = post(path, data, :accept => "application/json")
      MultiJson.decode(body, :symbolize_keys => true)
    end

    def post(path, data, options = {})
      connection[path].post(data.to_json, options)
    end

    def connection
      @connection ||= RestClient::Resource.new(@uri.to_s_without_extras, @uri.user, @uri.password)
    end
  end
end
