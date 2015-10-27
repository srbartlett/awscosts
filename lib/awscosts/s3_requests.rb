require 'httparty'

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
        r['types'].each do |tier|
          tier['tiers'].each do |t|
            tiers[t['name']] = { rate: t['rate'], price: t['prices']['USD'].to_f}
          end
        end
        result[r['region']] = tiers
      end
      result
    end
    self.new(transformed[region])
  end
end
