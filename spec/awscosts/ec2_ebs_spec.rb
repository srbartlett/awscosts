require 'spec_helper'

describe AWSCosts::EBS do
  use_vcr_cassette

  AWSCosts::Region::SUPPORTED.keys.each do |region|
    context "in the region of #{region}" do
      subject { AWSCosts.region(region).ec2.ebs}

      ['Amazon EBS General Purpose (SSD) volumes',
       'Amazon EBS Provisioned IOPS (SSD) volumes',
       'Amazon EBS Magnetic volumes', 'ebsSnapsToS3'].each do |name|

          describe "for '#{name}'" do
            let(:price) { subject.price.find { |p| p['name'] == name } }

            it 'should provide a name' do
              price['name'].should_not be_nil
            end

            it 'should provide values ' do
              price['values'].should_not be_nil
            end
          end
       end
     end
  end
end


