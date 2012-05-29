require 'uri'
require 'rest-client'
require 'multi_json'

module Candidate
  class Connection
    def initialize(uri)
      @uri = uri
    end

    def default_manifest
      Manifest.new(backend.manifest(manifest_name), self)
    end

    def destroy_manifest(manifest)
      backend.destroy_manifest(manifest)
    end

    def fork_manifest(name, fork_name)
      Manifest.new(backend.fork_manifest(name, fork_name), self)
    end

    def manifest(name)
      Manifest.new(backend.manifest(name), self)
    end

    def manifests
      backend.manifests.map { |m| Manifest.new(m, self) }
    end

    def create_release(manifest, components)
      backend.create_release(manifest, components)
    end

    def releases(manifest)
      backend.releases(manifest).map { |r| Release.new(r.merge(:manifest_name => manifest), self) }
    end

    def app_name
      @uri.host.split('.')[0]
    end

    def manifest_name
      @uri.fragment
    end

    private

    def backend
      @backend ||= Candidate.backend.new(@uri)
    end
  end
end
