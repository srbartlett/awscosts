require 'spec_helper'

describe AWSCosts::ElasticIPs do
  use_vcr_cassette

  subject { AWSCosts.region('ap-southeast-2').ec2.elastic_ips}

  its(:price_one) { should == 0 }
  its(:price_additional_per_hour) { should > 0 }
  its(:price_non_attached_per_hour) { should > 0 }
  its(:price_remap_first_100) { should == 0 }
  its(:price_remap_over_100) { should > 0 }

end

