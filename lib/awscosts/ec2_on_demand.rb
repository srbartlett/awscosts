require 'awscosts/ec2'

class AWSCosts::EC2OnDemand

  TYPE_TRANSLATION = { 'stdODI.sm' => 'm1.small',
                     'stdODI.med' => 'm1.medium',
                     'stdODI.lg' => 'm1.large',
                     'stdODI.xl' => 'm1.xlarge',
                     'secgenstdODI.xl' => 'm3.xlarge',
                     'secgenstdODI.xxl' => 'm3.2xlarge',
                     'uODI.u' => 't1.micro',
                     'hiMemODI.xl' => 'm2.xlarge',
                     'hiMemODI.xxl' => 'm2.2xlarge',
                     'hiMemODI.xxxxl' => 'm2.4xlarge',
                     'hiCPUODI.med' => 'c1.medium',
                     'hiCPUODI.xl' => 'c1.xlarge',
                     'clusterComputeI.xxxxl' => 'cc1.4xlarge',
                     'clusterComputeI.xxxxxxxxl' => 'cc2.8xlarge',
                     'clusterGPUI.xxxxl' => 'cg1.4xlarge',
                     'clusterHiMemODI.xxxxxxxxl' => 'cr1.8xlarge',
                     'hiStoreODI.xxxxxxxxl' => 'hs1.8xlarge',
                     'hiIoODI.xxxxl' => 'hi1.4xlarge' }

  def initialize data
    @data = data
  end

  def price size=nil
    size ? @data[size] : @data
  end

  def self.fetch type, region
    result = {}
    ['/pricing/1/ec2/%s-od.min.js', '/pricing/1/ec2/previous-generation/%s-od.min.js'].each do |uri|
      AWSCosts::Cache.get_jsonp(uri % type) do |data|
        data['config']['regions'].each do |r|
          result[r['region']] ||= {}
          platforms = result[r['region']]
          r['instanceTypes'].each do |instance_type|
            instance_type['sizes'].each do |instance_size|
              size = instance_size['size']
              platform_cost = Hash.new({})
              instance_size['valueColumns'].each do |value|
                # Don't return 0.0 for "N/A" since that is misleading
                platform_cost[value['name']] = value['prices']['USD'] == 'N/A' ? nil : value['prices']['USD'].to_f
              end

              platform_cost.each_pair do |p,v|
                platforms[p] = {} unless platforms.key?(p)
                platforms[p][size] = v
              end
            end
          end
        end
      end
    end

    raise "No result for region #{region} while fetching EC2 OnDemand Pricing"            if result[region].nil?
    raise "No result for #{type} in region #{region} while fetching EC2 OnDemand Pricing" if result[region][type].nil?

    self.new(result[region][type])
  end

end

