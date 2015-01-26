require "capistrano/rtrack/version"

module Capistrano
  module Rtrack
    def run
      conn = Faraday.new(url: "http://rtrack.ru/webhooks/capistrano") do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      resp = conn.send :post, {
        sha: fetch(:current_revision),
        app: fetch(:rtrack),
        env: fetch(:stage)
      }
    rescue => e
      puts "Error during rtrack webhook: #{e.message}"
    end
  end
end


load File.expand_path('../rtrack/tasks.rake', __FILE__)
