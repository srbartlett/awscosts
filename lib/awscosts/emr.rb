require 'httparty'
require 'json'

class AWSCosts::EMR

  TYPE_TRANSLATION = { 'stdODI.sm' => 'm1.small',
                     'stdODI.med' => 'm1.medium',
                     'stdODI.lg' => 'm1.large',
                     'stdODI.xl' => 'm1.xlarge',
                     'hiMemODI.xl' => 'm2.xlarge',
                     'hiMemODI.xxl' => 'm2.2xlarge',
                     'hiMemODI.xxxxl' => 'm2.4xlarge',
                     'hiCPUODI.med' => 'c1.medium',
                     'hiCPUODI.xl' => 'c1.xlarge',
                     'clusterComputeI.xxxxl' => 'cc1.4xlarge',
                     'clusterComputeI.xxxxxxxxl' => 'cc2.8xlarge',
                     'clusterGPUI.xxxxl' => 'cg1.4xlarge',
                     'hiStoreODI.xxxxxxxxl' => 'hs1.8xlarge',
                     'hiIOODI.xxxxl' => 'hi1.4xlarge' }

  def initialize data
    @data= data
  end

  def ec2_price size=nil
    size ? @data['ec2'][size] : @data['ec2']
  end

  def emr_price size=nil
    size ? @data['emr'][size] : @data['emr']
  end

  def self.fetch region
    transformed= AWSCosts::Cache.get("/elasticmapreduce/pricing/pricing-emr.json") do |data|
      result = {}
      data['config']['regions'].each do |region|
        platforms = {}
        region['instanceTypes'].each do |instance_type|
          type = instance_type['type']
          instance_type['sizes'].each do |instance_size|
            size = instance_size['size']
            platform_cost = Hash.new({})
            instance_size['valueColumns'].each do |value|
              platform_cost[value['name']] = value['prices']['USD'].to_f
            end
            platform_cost.each_pair do |p,v|
              platforms[p] = {} unless platforms.key?(p)
              platforms[p][TYPE_TRANSLATION["#{type}.#{size}"]] = v
            end
          end
        end
        result[region['region']] = platforms
      end
      result
    end
    self.new(transformed[region])
  end

end

