require 'httparty'
require 'json'

class AWSCosts::EBSOptimized

  def initialize data
    @data = data
  end

  def price type = nil
    type.nil? ? @data : @data[type]
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/ec2/pricing-ebs-optimized-instances.min.js') do |data|
      result = {}
      data['config']['regions'].each do |r|
        container = {}
        r['instanceTypes'].each do |type|
          type['sizes'].each do |size|
            container[size['size']] = size['valueColumns'].select{|v| v['name'] == 'ebsOptimized'}.first['prices']['USD'].to_f
          end
        end
        result[r['region']] = container
      end
      result
    end
    self.new(transformed[region])
  end

end

