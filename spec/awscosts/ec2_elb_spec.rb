require 'spec_helper'

describe AWSCosts::ELB do
  use_vcr_cassette

  subject { AWSCosts.region('ap-southeast-2').ec2.elb}

  its(:price_per_hour) { should > 0 }
  its(:price_per_gb) { should > 0 }

end

