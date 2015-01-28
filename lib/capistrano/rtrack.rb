require "capistrano/rtrack/version"
require 'capistrano/version'
require 'faraday'
require 'json'

module Capistrano
  module Rtrack
    def self.run
      conn = Faraday.new(url: "http://rtrack.ru") do |faraday|
        faraday.request :url_encoded
      end
      puts "notifying rtrack, deployed sha #{fetch(:current_revision)} of #{fetch(:rtrack)} to #{fetch(:stage)}"
      resp = conn.post '/webhooks/capistrano', {
        sha: fetch(:current_revision) || "",
        app: fetch(:rtrack),
        env: fetch(:stage)
      }
    rescue => e
      puts "Error during rtrack webhook: #{e.message}"
      #puts e.backtrace
    end
  end
end

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path('../rtrack/tasks.rake', __FILE__)
end

