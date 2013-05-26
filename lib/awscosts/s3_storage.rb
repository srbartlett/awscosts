require 'httparty'
require 'json'

class AWSCosts::S3Storage

  TIERS = %w{firstTBstorage, next49TBstorage, next49TBstorage, next501TBstorage}

  def initialize data
    @data= data
  end

  def price tier = nil
    tier.nil? ? @data : @data[tier.to_s]
  end

  def self.fetch region
    @cache ||= begin
      result = {}
      data= JSON.parse(HTTParty.get("http://aws.amazon.com/s3/pricing/pricing-storage.json").body)
      data['config']['regions'].each do |region|
        tiers = {}
        region['tiers'].each do |tier|
          storage_type = {}
          tiers[tier['name']] = storage_type
          tier['storageTypes'].each do |type|
            storage_type[type['type']] = type['prices']['USD'].to_f
          end
        end
        result[region['region']] = tiers
      end
      result
    end
    self.new(@cache[region])
  end

end


