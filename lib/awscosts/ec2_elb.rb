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
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ec2/pricing-elb.min.js') do |data|
      result = {}
      data['config']['regions'].each do |r|
        container = {}
        r['types'].each do |type|
          type['values'].each do |value|
            container[value['rate']] = value['prices']['USD'].to_f
          end
        end
        result[r['region']] = container
      end
      result
    end
    self.new(transformed[region])
  end

end
