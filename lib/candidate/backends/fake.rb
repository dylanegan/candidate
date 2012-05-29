module Candidate::Backends
  class Fake
    def initialize(uri); end

    def self.reset!
      @manifests = []
    end

    def self.create_manifest(name)
      manifests << { :name => name }
    end

    def create_release(manifest, components)
      releases(manifest) << {
        :components => components
      }
    end

    def destroy_manifest(name)
      manifests.delete_if { |m| m[:name] == name }
    end

    def fork_manifest(name, fork_name)
      attributes = { :name => fork_name }
      manifests << attributes

      if release = releases(name).last
        releases(fork_name) << release
      end

      attributes
    end

    def manifest(name)
      manifests.find { |m| m[:name] == name }
    end

    def manifests
      self.class.manifests
    end

    def self.manifests
      @manifests ||= []
    end

    def releases(manifest)
      self.class.releases(manifest)
    end

    def self.releases(manifest)
      @releases ||= {}
      @releases[manifest] ||= []
    end
  end
end
