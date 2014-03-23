require 'httparty'
require 'json'

module AWSCosts::Cache
  extend self

  BASE_URI = "http://aws.amazon.com"

  def get uri, base_uri = BASE_URI, &block
    cache[uri] ||= begin
      yield JSON.parse(HTTParty.get("#{base_uri}#{uri}").body)
     end
  end

  private
  def cache
    @cache ||= {}
  end

end


