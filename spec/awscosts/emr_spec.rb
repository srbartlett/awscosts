require 'spec_helper'

describe AWSCosts::EMR do
  use_vcr_cassette

  subject { AWSCosts.region('eu-west-1').emr}

  it 'should provide an EMR price' do
    subject.emr_price('m1.xlarge') { should > 0 }
  end

  it 'should provide an EMR EC2 price' do
    subject.ec2_price('m1.xlarge') { should > 0 }
  end
end
