require 'httparty'
require 'json'

class AWSCosts::S3Requests

  TIERS = %w{putcopypost, glacierRequests, deleteRequests, getEtc, glacierDataRestore}

  def initialize data
    @data= data
  end

  def price tier = nil
    tier.nil? ? @data : @data[tier.to_s]
  end

  def self.fetch region
    transformed= AWSCosts::Cache.get("/s3/pricing/pricing-requests.json") do |data|
      result = {}
      data['config']['regions'].each do |region|
        tiers = {}
        region['tiers'].each do |tier|
          tiers[tier['name']] = { rate: tier['rate'], price: tier['prices']['USD'].to_f}
        end
        result[region['region']] = tiers
      end
      result
    end
    self.new(transformed[region])
  end

end


