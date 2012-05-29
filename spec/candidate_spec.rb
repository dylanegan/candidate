require 'helper'
require 'candidate'

Candidate.mock!

describe Candidate do
  subject { Candidate }

  before do
    subject.reset!
    @candidate = subject.new ''
  end

  describe "#manifests" do
    before do
      create_manifest "testing"
    end

    it "should not be empty" do
      @candidate.manifests.wont_be_empty
    end

    it "returns Manifest objects" do
      @candidate.manifests.first.must_be_instance_of Candidate::Manifest
    end

    it "returns the correct manifests" do
      @candidate.manifests.first.name.must_equal "testing"
    end

    describe "#fork" do
      before do
        @manifest = @candidate.manifests.first
        @manifest.release({"component" => "v1"})
        @forked = @manifest.fork("forked-testing")
      end

      it "should fork the manifest" do
        @forked.releases.first.components.must_equal @manifest.releases.last.components
      end
    end

    describe "#releases" do
      before do
        @manifest = @candidate.manifests.first

        @manifest.release({"component" => "v1"})
      end

      it "should not be empty" do
        @manifest.releases.wont_be_empty
      end

      it "returns Release objects" do
        @manifest.releases.first.must_be_instance_of Candidate::Release
      end

      it "returns the correct releases" do
        @manifest.releases.first.components.must_equal({ "component" => "v1" })
      end
    end
  end

  def create_manifest(*a)
    Candidate::Backends::Fake.create_manifest(*a)
  end
end
