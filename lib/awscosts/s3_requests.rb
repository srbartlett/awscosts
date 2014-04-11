require 'httparty'
require 'json'

class AWSCosts::S3Requests

  def initialize data
    @data = data
  end

  def price tier = nil
    tier.nil? ? @data : @data[tier.to_s]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp("/pricing/1/s3/pricing-requests-s3.min.js") do |data|
      result = {}
      data['config']['regions'].each do |r|
        tiers = {}
        r['tiers'].each do |tier|
          tiers[tier['name']] = { rate: tier['rate'], price: tier['prices']['USD'].to_f}
        end
        result[r['region']] = tiers
      end
      result
    end
    self.new(transformed[region])
  end

end


