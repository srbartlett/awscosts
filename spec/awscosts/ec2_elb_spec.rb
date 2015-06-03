require 'spec_helper'

describe AWSCosts::ELB do
  use_vcr_cassette

  subject { AWSCosts.region('ap-southeast-2').ec2.elb}

  it { expect(subject.price_per_hour).to be > 0 }
  it { expect(subject.price_per_gb).to be > 0 }

end

