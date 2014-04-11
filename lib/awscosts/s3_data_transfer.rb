require 'httparty'
require 'json'

class AWSCosts::S3DataTransfer

  TYPES = %w{dataXferInS3, dataXferOutS3CrossRegion, dataXferOutS3}

  def initialize data
    @data = data
  end

  def price type = nil
    type.nil? ? @data : @data[type.to_s]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp("/pricing/1/s3/pricing-data-transfer-s3.min.js") do |data|
      result = {}
      data['config']['regions'].each do |r|
        types = {}
        r['types'].each do |type|
          types[type['name']] = {}
          type['tiers'].each do |tier|
            # Don't return 0.0 for "contactus" since that is misleading
            types[type['name']][tier['name']] = tier['prices']['USD'] == 'contactus' ? nil : tier['prices']['USD'].to_f
          end
        end
        result[r['region']] = types
      end
      result
    end
    self.new(transformed[region])
  end

end


