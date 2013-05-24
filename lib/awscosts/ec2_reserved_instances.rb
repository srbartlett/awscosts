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
      @data["#{TERMS[term]}Hourly"][size]
    end
  end


  def self.fetch type, utilisation, region
    raw_data= cache[type] ||= begin
      result = {}
      data= JSON.parse(HTTParty.get("http://aws.amazon.com/ec2/pricing/json/#{AWSCosts::EC2::TYPES[type]}-ri-#{utilisation}.json").body)
      data['config']['regions'].each do |region|
        platforms = {}
        region['instanceTypes'].each do |instance_type|
          type = instance_type['type']
          instance_type['sizes'].each do |instance_size|
            size = instance_size['size']
            platform_cost = Hash.new({})

            instance_size['valueColumns'].each do |value|
              platform_cost[value['name']] = value['prices']['USD']
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
    self.new(raw_data[region])
  end


  private
  def self.cache
    @@cache ||= {}
  end
end

