class AWSCosts::ElasticIPs

  def initialize data
    @data= data
  end

  def price_one
    @data['oneEIP']
  end

  def price_additional_per_hour
    @data['perAdditionalEIPPerHour']
  end

  def price_non_attached_per_hour
    @data['perNonAttachedPerHour']
  end

  def price_remap_first_100
    @data['perRemapFirst100']
  end

  def price_remap_over_100
    @data['perRemapOver100']
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ec2/pricing-elastic-ips.min.js') do |data|
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
