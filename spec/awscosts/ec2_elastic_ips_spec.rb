require 'spec_helper'

describe AWSCosts::ElasticIPs do
  use_vcr_cassette

  AWSCosts::Region::SUPPORTED.keys.each do |region|

    context "in the region of #{region}" do
      subject { AWSCosts.region(region).ec2.elastic_ips}

      it { expect(subject.price_one).to eql(0.0) }
      it { expect(subject.price_additional_per_hour).to be > 0 }
      it { expect(subject.price_non_attached_per_hour).to be > 0 }
      it { expect(subject.price_remap_first_100).to eql(0.0) }
      it { expect(subject.price_remap_over_100).to be > 0 }
    end
  end
end

