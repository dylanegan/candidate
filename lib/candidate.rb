require 'uri'

module Candidate
  def self.mock!
    @mock = true
  end

  def self.mocking?
    @mock
  end

  def self.reset!
    Backends::Fake.reset!
  end

  def self.new(uri)
    @uri = URI.parse(uri.to_s)
    Connection.new(@uri)
  end

  def self.backend
    @backend ||= mocking? ? Backends::Fake : Backends::HTTP
  end

  def self.backend=(new_backend)
    @backend = new_backend
  end

  class NotFound < StandardError; end
end

require 'candidate/backends/fake'
require 'candidate/backends/http'
require 'candidate/connection'
require 'candidate/manifest'
require 'candidate/release'
