require 'httparty'
require 'json'

module AWSCosts::Cache
  extend self

  BASE_URI = "http://aws.amazon.com"

  def get uri, &block
    cache[uri] ||= begin
      yield JSON.parse(HTTParty.get("#{BASE_URI}#{uri}").body)
     end
  end

  private
  def cache
    @cache ||= {}
  end

end


