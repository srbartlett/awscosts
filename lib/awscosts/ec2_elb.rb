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
    transformed= AWSCosts::Cache.get('/ec2/pricing/pricing-elb.json') do |data|
      result = {}
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
    self.new(transformed[region])
  end

end
