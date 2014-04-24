require 'httparty'
require 'json'

module AWSCosts::Cache
  extend self

  BASE_URI = "http://aws.amazon.com"
  BASE_JSONP_URI = "http://a0.awsstatic.com"

  def get uri, base_uri = BASE_URI, &block
    cache["#{base_uri}#{uri}"] ||= JSON.parse(HTTParty.get("#{base_uri}#{uri}").body)
    yield cache["#{base_uri}#{uri}"]
  end

  def get_jsonp uri, base_uri = BASE_JSONP_URI, &block
    attempts = 0
    cache["#{base_uri}#{uri}"] ||= begin
      extract_json_from_callback(HTTParty.get("#{base_uri}#{uri}").body)
    rescue NoMethodError
      attempts += 1
      retry if attempts < 5
      raise "Failed to retrieve or parse data for #{base_uri}#{uri}"
    end

    yield cache["#{base_uri}#{uri}"]
  end

  private
  def cache
    @cache ||= {}
  end

  def extract_json_from_callback body
    body.match /^.*callback\((\{.*\})\);$/
    body = $1

    # Handle "json" with keys that are not quoted
    # When we get {foo: "1"} instead of {"foo": "1"}
    # http://stackoverflow.com/questions/2060356/parsing-json-without-quoted-keys
    JSON.parse(body.gsub(/(\w+)\s*:/, '"\1":'))
  end
end


