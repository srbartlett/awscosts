require 'spec_helper'

describe AWSCosts::S3Requests do
  use_vcr_cassette

  AWSCosts::Region::SUPPORTED.keys.each do |region|
    context "in the region of #{region}" do
      subject { AWSCosts.region(region).s3.requests}
      it { expect(subject.price).to have_key('putcopypost') }
    end
  end
end

