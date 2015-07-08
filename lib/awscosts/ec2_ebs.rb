require 'httparty'

class AWSCosts::EBS

  def initialize data
    @data= data
  end

  def price type = nil
    type.nil? ? @data : @data[type]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ebs/pricing-ebs.min.js') do |data|
      result = {}
      data['config']['regions'].each do |r|
        result[r['region']] = r['types']
      end
      result
    end
    self.new(transformed[region])
  end

end

