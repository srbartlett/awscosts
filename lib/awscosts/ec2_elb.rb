require 'httparty'
require 'json'

class AWSCosts::ELB

  def initialize data
    @data= data
  end

  def price_per_hour
    @data['perELBHour']
  end

  def price_per_gb
    @data['perGBProcessed']
  end

  def self.fetch region
    @fetch ||= begin
      result = {}
      data= JSON.parse(HTTParty.get('http://aws.amazon.com/ec2/pricing/pricing-elb.json').body)
      data['config']['regions'].each do |region|
        container = {}
        region['types'].each do |type|
          type['values'].each do |value|
            container[value['rate']] = value['prices']['USD'].to_f
          end
        end
        result[region['region']] = container
      end
      result
    end
    self.new(@fetch[region])
  end

end
