require 'spec_helper'

describe AWSCosts::S3DataTransfer do
  use_vcr_cassette

  AWSCosts::Region::SUPPORTED.keys.each do |region|
    context "in the region of #{region}" do
      subject { AWSCosts.region(region).s3.data_transfer}

      it { expect(subject.price).to have_key('dataXferInS3') }
    end
  end
end


