require 'spec_helper'

describe AWSCosts::S3Storage do
  use_vcr_cassette

  AWSCosts::Region::SUPPORTED.keys.each do |region|
    context "in the region of #{region}" do
      subject { AWSCosts.region(region).s3.storage}

      it { expect(subject.price).to have_key('firstTBstorage') }
      it { expect(subject.price).to have_key('next49TBstorage') }
    end
  end
end



