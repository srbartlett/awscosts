require 'awscosts/ec2_on_demand'
require 'awscosts/ec2_reserved_instances'
require 'awscosts/ec2_elb'
require 'awscosts/ec2_ebs'
require 'awscosts/ec2_elastic_ips'

class AWSCosts::EC2

  attr_reader :region

  TYPES = { windows: 'mswin', linux: 'linux', windows_with_sql: 'mswinSQL',
            windows_with_sql_web: 'mswinSQLWeb', rhel: 'rhel', sles: 'sles' }

  def initialize region
    @region = region
  end

  def on_demand(type)
    AWSCosts::EC2OnDemand.fetch(TYPES[type], self.region.price_mapping)
  end

  def reserved(type, utilisation= :light)
    AWSCosts::EC2ReservedInstances.fetch(TYPES[type], utilisation, self.region.name)
  end

  def elb
    AWSCosts::ELB.fetch(self.region.price_mapping)
  end

  def ebs
    AWSCosts::EBS.fetch(self.region.price_mapping)
  end

  def elastic_ips
    AWSCosts::ElasticIPs.fetch(self.region.price_mapping)
  end
end


