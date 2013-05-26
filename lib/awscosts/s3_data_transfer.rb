require 'httparty'
require 'json'

class AWSCosts::S3DataTransfer

  TYPES = %w{dataXferInS3, dataXferOutS3CrossRegion, dataXferOutS3}

  def initialize data
    @data= data
  end

  def price type = nil
    type.nil? ? @data : @data[type.to_s]
  end

  def self.fetch region
    @cache ||= begin
      result = {}
      data= JSON.parse(HTTParty.get("http://aws.amazon.com/s3/pricing/pricing-data-transfer.json").body)
      data['config']['regions'].each do |region|
        types = {}
        region['types'].each do |type|
          types[type['name']] = {}
          type['tiers'].each do |tier|
            types[type['name']][tier['name']] = tier['prices']['USD'].to_f
          end
        end
        result[region['region']] = types
      end
      result
    end
    self.new(@cache[region])
  end

end


