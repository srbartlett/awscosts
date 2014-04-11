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
    transformed = AWSCosts::Cache.get('/ec2/pricing/pricing-ebs-optimized-instances.json') do |data|
      result = {}
      data['config']['regions'].each do |region|
        container = {}
        region['instanceTypes'].each do |type|
          type['sizes'].each do |size|
            container[size['size']] = size['valueColumns'].select{|v| v['name'] == 'ebsOptimized'}.first['prices']['USD']
          end
        end
        result[region['region']] = container
      end
      result
    end
    raise "EBS Optimized pricing in region #{region} not found." if transformed[region].nil?
    self.new(transformed[region])
  end

end

