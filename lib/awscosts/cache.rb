require 'httparty'
require 'json'

module AWSCosts::Cache
  extend self

  BASE_URI = "http://aws.amazon.com"
  BASE_JSONP_URI = "http://a0.awsstatic.com"

  def get uri, base_uri = BASE_URI, &block
    cache[uri] ||= begin
      yield JSON.parse(HTTParty.get("#{base_uri}#{uri}").body)
     end
  end

  def get_jsonp uri, base_uri = BASE_JSONP_URI, &block
    cache[uri] ||= begin
      yield extract_json_from_callback(HTTParty.get("#{base_uri}#{uri}").body)
    end
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


