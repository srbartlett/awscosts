require 'httparty'
require 'json'

class AWSCosts::S3Storage

  def initialize data
    @data = data
  end

  def price tier = nil
    tier.nil? ? @data : @data[tier.to_s]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp("/pricing/1/s3/pricing-storage-s3.min.js") do |data|
      result = {}
      data['config']['regions'].each do |r|
        tiers = {}
        r['tiers'].each do |tier|
          storage_type = {}
          tiers[tier['name']] = storage_type
          tier['storageTypes'].each do |type|
            # Don't return 0.0 for "N/A*" since that is misleading
            storage_type[type['type']] = type['prices']['USD'] == 'N/A*' ? nil : type['prices']['USD'].to_f
          end
        end
        result[r['region']] = tiers
      end
      result
    end
    self.new(transformed[region])
  end

end

