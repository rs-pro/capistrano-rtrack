require 'net/http'
require 'uri'
require 'json'

module Capistrano
  module Rtrack
    class Client

      def initialize(base_url, token)
        puts "rtrack base url: #{base_url}"
        @base_url = base_url
        @token = token
      end

      def deploy_started(params)
        post("start", params)
      end

      def deploy_finished(deploy_id)
        post("/#{deploy_id}/finished")
      end

      def deploy_failed(deploy_id)
        post("/#{deploy_id}/failed")
      end

      private
      def post(url, params = {})
        uri = URI.parse("#{@base_url}/deploys#{url}")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = JSON.dump(params)
        request["Access-Token"] = "Bearer " + @token
        req_options = {
          use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end

        if response.code != 200
          raise "bad status code #{response.code}"
        end

        JSON.parse(response.body)
      rescue Exception => e
        puts "Rtrack error: #{e.class.name}: #{e.message}"
        puts e.backtrace[0..10].join("\n")
        nil
      end
    end
  end
end

