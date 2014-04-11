require 'httparty'
require 'json'
class AWSCosts::EC2ReservedInstances

  TERMS = { one_year: 'yrTerm1', three_year: 'yrTerm3' }

  TYPE_TRANSLATION = { 'stdResI.sm' => 'm1.small',
                     'stdResI.med' => 'm1.medium',
                     'stdResI.lg' => 'm1.large',
                     'stdResI.xl' => 'm1.xlarge',
                     'secgenstdResI.xl' => 'm3.xlarge',
                     'secgenstdResI.xxl' => 'm3.2xlarge',
                     'uResI.u' => 't1.micro',
                     'hiMemResI.xl' => 'm2.xlarge',
                     'hiMemResI.xxl' => 'm2.2xlarge',
                     'hiMemResI.xxxxl' => 'm2.4xlarge',
                     'hiCPUResI.med' => 'c1.medium',
                     'hiCPUResI.xl' => 'c1.xlarge',
                     'clusterComputeI.xxxxl' => 'cc1.4xlarge',
                     'clusterComputeI.xxxxxxxxl' => 'cc2.8xlarge',
                     'clusterGPUI.xxxxl' => 'cg1.4xlarge',
                     'clusterHiMemResI.xxxxxxxxl' => 'cr1.8xlarge',
                     'hiStoreResI.xxxxxxxxl' => 'hs1.8xlarge',
                     'hiIoResI.xxxxl' => 'hi1.4xlarge' }
  def initialize data
    @data= data
  end

  def upfront term, size=nil
    if size
      @data[TERMS[term]][size]
    else
      @data[TERMS[term]]
    end
  end

  def hourly term, size=nil
    if size
      @data["#{TERMS[term]}Hourly"][size]
    else
      @data["#{TERMS[term]}Hourly"]
    end
  end

  def self.fetch type, utilisation, region
    transformed = AWSCosts::Cache.get_jsonp("/pricing/1/ec2/#{type}-ri-#{utilisation}.min.js") do |data|
      result = {}
      data['config']['regions'].each do |r|
        platforms = {}
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
        result[r['region']] = platforms
      end
      result
    end
    self.new(transformed[region])
  end

end

