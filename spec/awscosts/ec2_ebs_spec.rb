require 'spec_helper'

describe AWSCosts::EBS do
  use_vcr_cassette

  subject { AWSCosts.region('ap-southeast-2').ec2.ebs}

  describe 'standard EBS volume' do
    let(:price) { subject.price(:standard) }

    it 'should provide price per GB / month for provisioned storage' do
      price['perGBmoProvStorage'].should > 0
    end

    it 'should provide price per Million requests per month' do
      price['perMMIOreq'].should > 0
    end
  end

  describe 'provisioned IOPS price' do
    let(:price) { subject.price(:provisioned_iops) }

    it 'should provide price per GB / month for provisioned storage' do
      price['perGBmoProvStorage'].should > 0
    end

    it 'should provide a price per PIOPS' do
      price['perPIOPSreq'].should > 0
    end
  end

  describe 'Snapshots to S3' do
    let(:price) { subject.price(:snapshots_to_s3) }

    it 'should provide a price per GB stored / month' do
      price['perGBmoDataStored'].should > 0
    end
  end

end


